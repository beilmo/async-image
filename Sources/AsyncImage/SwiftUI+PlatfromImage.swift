//
//  File.swift
//  
//
//  Created by Dorin Danciu on 18/06/2020.
//

import Foundation
import SwiftUI

#if os(macOS)

extension SwiftUI.Image {
    public init(image: PlatformImage) {
        self.init(nsImage: image)
    }
}

#elseif canImport(UIKit)

extension SwiftUI.Image {
    public init(image: PlatformImage) {
        self.init(uiImage: image)
    }
}

#endif
