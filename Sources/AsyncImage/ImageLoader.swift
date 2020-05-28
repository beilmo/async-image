//
//  ImageLoader.swift
//  AsyncImage
//
//  Created by Dorin Danciu on 28/05/2020.
//  Copyright © 2020 Beilmo. All rights reserved.
//

import Foundation
import Combine

fileprivate extension DispatchQueue {

    /// The dispatch queue responsible of image loading processes.
    static let imageLoadingQueue = DispatchQueue(label: "image-loading")
}

extension ImageLoader {
    public enum Status {
        case unknown
        case waiting
        case loading
        case completed
        case failed
        case canceled
    }
}
/// Loads a remote Image asynchronously.
public class ImageLoader: ObservableObject {

    /// The image being managed by the image loader.
    @Published private(set) public var image: Image?

    /// A Boolean value indicating whether the operation is currently executing.
    @Published private(set) public var status = Status.unknown

    /// The remote address used by the image loader to download the image.
    private let url: URL

    /// The Image cache instance used by the loaded to cache the loaded result.
    private var cache: ImageCache?

    /// A Cancellable value responsible of the inner data task publisher launched by the loader.
    private var cancellable: AnyCancellable?

    /// Creates a new Image Loader instance responsible of retriving the remote Image hosted and the specified URL.
    /// Optionally you can specify a cachd destination to be used by the instance if you want the result to be cached.
    /// - Parameters:
    ///   - url: location of the remote Image
    ///   - cache: instance to be used to store the downloaded result
    public init(url: URL, cache: ImageCache? = nil) {
        self.url = url
        self.cache = cache
    }

    deinit {
        cancellable?.cancel()
    }

    /// Begins the execution of the taks.
    public func load() {
        guard status != .waiting && status != .loading else { return }

        status = .waiting

        if let cachedImage = cache?[url] {
            image = cachedImage
            status = .completed
            return
        }

        cancellable = URLSession.shared.dataTaskPublisher(for: url)
            .map { Image(data: $0.data) }
            .handleEvents(receiveSubscription: { [weak self] in self?.onStart($0) },
                          receiveOutput: { [weak self] in self?.cache($0) },
                          receiveCompletion: { [weak self] in self?.onFinish($0) },
                          receiveCancel: { [weak self] in self?.onCancel() })
            .replaceError(with: nil)
            .subscribe(on: DispatchQueue.imageLoadingQueue)
            .receive(on: DispatchQueue.main)
            .assign(to: \.image, on: self)
    }

    /// Advises the object that it should stop executing its task.
    public func cancel() {
        guard status == .waiting || status == .loading  else { return }

        status = .canceled
        cancellable?.cancel()
    }

    private func onStart(_ subscription: Subscription) {
        if status == .waiting {
            status = .loading
        } else {
            subscription.cancel()
        }
    }

    private func onCancel() {
        status = .canceled
    }

    private func onFinish(_ completion: Subscribers.Completion<URLError>) {
        switch completion {
            case .finished:
                status = .completed
            case .failure(_):
                status = .failed
        }
    }

    private func cache(_ image: Image?) {
        image.map { cache?[url] = $0 }
    }
}
