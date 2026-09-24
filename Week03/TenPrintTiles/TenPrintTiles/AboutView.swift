//
//  AboutView.swift
//  TenPrintTiles
//
//  Created by Jackie Nam on 9/24/26.
//

import SwiftUI

// Third tab. Plain text describing what the other two tabs do.

struct AboutView: View {
  var body: some View {
    VStack(alignment: .leading, spacing: 16) {
      Text("About")
        .font(.title)

      Text("10 Print draws a grid of diagonal lines. Each cell picks its direction with Bool.random() and its color with randomElement() on an array of colors.")

      Text("Symbol Grid does the same thing with SF Symbols instead of lines.")

      Text("Both screens build an array first, then draw the array. Tap Shuffle to make a new one.")

      Spacer()
    }
    .padding()
  }
}

#Preview {
  AboutView()
}
