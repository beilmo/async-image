//
//  AvatarImage.swift
//  Sample
//
//  Created by Dorin Danciu on 18/06/2020.
//  Copyright © 2020 Beilmo. All rights reserved.
//

import Foundation
import SwiftUI
import AsyncImage

struct AvatarImage: View {
    @Environment(\.imageCache) var cache: ImageCache

    let url: URL

    var body: some View {
        AsyncImage(url: url, cache: cache, placeholder: {
            AvatarPlaceholder()
        }).mask(Circle().fill(Color.black))
    }
}

struct AvatarPlaceholder: View {
    var body: some View {
        GeometryReader { reader in
            ZStack {
                Rectangle().fill(Color.gray)
                SwiftUI.Image(systemName: "person.crop.circle")
                    .resizable()
                    .frame(width: min(reader.size.width, reader.size.height),
                           height: min(reader.size.width, reader.size.height),
                           alignment: .center)
            }
        }

    }
}
