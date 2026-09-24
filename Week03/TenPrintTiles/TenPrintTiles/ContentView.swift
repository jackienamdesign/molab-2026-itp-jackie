//
//  ContentView.swift
//  TenPrintTiles
//
//  Created by Jackie Nam on 9/24/26.
//

import SwiftUI

// The multi view part of the app.
// TabView with .tabItem { Label(...) } copied from the pattern in
// 03-About-Me / ContentView.swift

struct ContentView: View {
  var body: some View {
    TabView {
      TenPrintView()
        .tabItem {
          Label("10 Print", systemImage: "line.diagonal")
        }

      SymbolGridView()
        .tabItem {
          Label("Symbols", systemImage: "square.grid.3x3")
        }

      AboutView()
        .tabItem {
          Label("About", systemImage: "info.circle")
        }
    }
  }
}

#Preview {
  ContentView()
}
