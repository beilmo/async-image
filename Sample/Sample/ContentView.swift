//
//  ContentView.swift
//  Sample
//
//  Created by Dorin Danciu on 28/05/2020.
//  Copyright © 2020 Beilmo. All rights reserved.
//

import SwiftUI
import AsyncImage

struct ContentView: View {
    var body: some View {
        List {
            ForEach((1...50), id: \.self) { index in
                ProfileRow(index: index)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
