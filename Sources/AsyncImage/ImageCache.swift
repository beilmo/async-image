//
//  ImageCache.swift
//  AsyncImage
//
//  Created by Dorin Danciu on 28/05/2020.
//  Copyright © 2020 Beilmo. All rights reserved.
//

import Foundation

/// A mutable collection you use to store transient url-image pairs.
public protocol ImageCache {
    subscript(_ url: URL) -> Image? { get set }
}

/// Thin abstraction layer on top of NSCache, conforming to `ImageCache`.
public struct TemporaryImageCache: ImageCache {
    private let cache = NSCache<NSURL, Image>()

    public subscript(_ key: URL) -> Image? {
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
