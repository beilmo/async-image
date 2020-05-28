//
//  Image.swift
//  AsyncImage
//
//  Created by Dorin Danciu on 28/05/2020.
//  Copyright © 2020 Beilmo. All rights reserved.
//

#if os(macOS)
import AppKit
#elseif os(iOS)
import UIKit
#endif

#if os(macOS)
public typealias Image = NSImage
#elseif os(iOS)
public typealias Image = UIImage
#endif
