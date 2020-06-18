//
//  ImageCache.swift
//  AsyncImage
//
//  Created by Dorin Danciu on 28/05/2020.
//  Copyright © 2020 Beilmo. All rights reserved.
//

import Foundation
import SwiftUI

/// A mutable collection you use to store transient url-image pairs.
public protocol ImageCache {
    subscript(_ url: URL) -> PlatformImage? { get set }
}

struct ImageCacheKey: EnvironmentKey {
    public static let defaultValue: ImageCache = TemporaryImageCache()
}

extension EnvironmentValues {
    public var imageCache: ImageCache {
        get { self[ImageCacheKey.self] }
        set { self[ImageCacheKey.self] = newValue }
    }
}

/// Thin abstraction layer on top of NSCache, conforming to `ImageCache`.
public struct TemporaryImageCache: ImageCache {
    private let cache = NSCache<NSURL, PlatformImage>()

    public subscript(_ key: URL) -> PlatformImage? {
        get {
            cache.object(forKey: key as NSURL)
        }
        set {
            if let newValue = newValue {
                cache.setObject(newValue, forKey: key as NSURL)
            } else {
                cache.removeObject(forKey: key as NSURL)
            }
        }
    }
}
