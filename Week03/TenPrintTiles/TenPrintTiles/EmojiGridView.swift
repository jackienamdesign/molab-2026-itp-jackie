//
//  EmojiGridView.swift
//  TenPrintTiles
//
//  Created by Jackie Nam on 9/24/26.
//

import SwiftUI

// Copy of SymbolGridView, but with my most used emojis instead of SF Symbols.
//
// The one real difference: emoji are not symbols, they are text. So this uses
// Text(tile) where SymbolGridView uses Image(systemName: tile.name).
// Emoji also carry their own color, so there is no color to pick here --
// the only random choice is which emoji lands in each cell.

let emojiCols = 5
let emojiRows = 8
let myEmojis = ["🥹", "😂", "🙂‍↔️", "🫶", "😊", "🥰",
                "🥲", "✋", "⚽️", "👵🏻", "🙃", "⚾️"]

func makeEmojis() -> [String] {
  var result: [String] = []
  for _ in 0..<(emojiCols * emojiRows) {
    result.append(myEmojis.randomElement()!)
  }
  return result
}

struct EmojiGridView: View {
  @State var emojis = makeEmojis()

  var body: some View {
    VStack {
      Text("My Emojis")
        .font(.title)

      // same nested ForEach layout as SymbolGridView
      VStack(spacing: 8) {
        ForEach(0..<emojiRows, id: \.self) { row in
          HStack(spacing: 8) {
            ForEach(0..<emojiCols, id: \.self) { col in
              Text(emojis[row * emojiCols + col])
                .font(.largeTitle)
            }
          }
        }
      }
      .padding()

      Button("Shuffle") {
        emojis = makeEmojis()
      }
      .font(.title2)
      .padding()
    }
  }
}

#Preview {
  EmojiGridView()
}
