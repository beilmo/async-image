//
//  GraphicalImage.swift
//  AsyncImage
//
//  Created by Dorin Danciu on 28/05/2020.
//  Copyright © 2020 Beilmo. All rights reserved.
//

import Foundation

#if os(macOS)

import AppKit

public typealias PlatformImage = NSImage

#elseif canImport(UIKit)

import UIKit

public typealias PlatformImage = UIImage

#endif
