//
//  AsyncImage.swift
//  AsyncImage
//
//  Created by Dorin Danciu on 28/05/2020.
//  Copyright © 2020 Beilmo. All rights reserved.
//

import SwiftUI
import Foundation

public struct AsyncImage<Placeholder>: View where Placeholder: View {
    @ObservedObject private var loader: ImageLoader
    private let placeholderViewBuilder: () -> Placeholder
    private let contentViewBuilder: (SwiftUI.Image) -> SwiftUI.Image
    
    public init(url: URL,
                cache: ImageCache? = nil,
                @ViewBuilder placeholder: @escaping () -> Placeholder,
                             @ViewBuilder content: @escaping (SwiftUI.Image) -> SwiftUI.Image) {
        loader = ImageLoader(url: url, cache: cache)
        placeholderViewBuilder = placeholder
        contentViewBuilder = content
    }
    
    public init(url: URL,
                cache: ImageCache? = nil,
                @ViewBuilder placeholder: @escaping () -> Placeholder) {
        self.init(url: url,
                  cache: cache,
                  placeholder: placeholder,
                  content: { $0.resizable() })
    }
    
    public var body: some View {
        Group(content: content)
    }
    
    private func content() -> some View {
        if loader.status == .completed, let downloadedImage = loader.image {
            return AnyView(
                contentViewBuilder(Image(image: downloadedImage))
            )
        } else {
            return AnyView(
                placeholderViewBuilder()
                    .onAppear(perform: loader.load)
                    .onDisappear(perform: loader.cancel)
            )
            
        }
    }
}
