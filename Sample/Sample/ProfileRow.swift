//
//  ProfileRow.swift
//  Sample
//
//  Created by Dorin Danciu on 18/06/2020.
//  Copyright © 2020 Beilmo. All rights reserved.
//

import Foundation
import SwiftUI

struct ProfileRow: View {
    let index: UInt

    var url: URL {
        URL(string: "https://picsum.photos/200/200?random=\(index)")!
    }

    var body: some View {
        HStack {
            AvatarImage(url: url)
                .frame(width: 64, height: 64, alignment: .leading)
                .padding(.trailing, 10)

            VStack(alignment: .leading) {
                Text("Lena Söderberg").font(.title)
                Text("Computer Vision Star")
            }
        }
    }
}
