//
//  SymbolGridView.swift
//  TenPrintTiles
//
//  Created by Jackie Nam on 9/24/26.
//

import SwiftUI

// A second random picture, made of SF Symbols instead of slashes.
// Image(systemName:) from 03-ImageUiDemo-1-symbols
// Same idea as TenPrintView: build an array of random elements, then draw it.

let symbolCols = 6
let symbolRows = 9
let symbolNames = [
  "star.fill", "heart.fill", "moon.fill", "cloud.fill",
  "bolt.fill", "leaf.fill", "flame.fill", "drop.fill",
  "circle.fill", "square.fill", "triangle.fill", "diamond.fill",
]

// One cell of the symbol grid
struct SymbolTile {
  var name: String
  var color: Color
}

func makeSymbols() -> [SymbolTile] {
  var result: [SymbolTile] = []
  for _ in 0..<(symbolCols * symbolRows) {
    let tile = SymbolTile(name: symbolNames.randomElement()!,
                          color: colorSpecs.randomElement()!)
    result.append(tile)
  }
  return result
}

struct SymbolGridView: View {
  @State var symbols = makeSymbols()

  var body: some View {
    VStack {
      Text("Symbol Grid")
        .font(.title)

      // nested ForEach to lay out rows of symbols
      VStack(spacing: 10) {
        ForEach(0..<symbolRows, id: \.self) { row in
          HStack(spacing: 10) {
            ForEach(0..<symbolCols, id: \.self) { col in
              let tile = symbols[row * symbolCols + col]
              Image(systemName: tile.name)
                .font(.title)
                .foregroundStyle(tile.color)
            }
          }
        }
      }
      .padding()

      Button("Shuffle") {
        symbols = makeSymbols()
      }
      .font(.title2)
      .padding()
    }
  }
}

#Preview {
  SymbolGridView()
}
