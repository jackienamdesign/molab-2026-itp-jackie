//
//  TenPrintView.swift
//  TenPrintTiles
//
//  Created by Jackie Nam on 9/24/26.
//

import SwiftUI

// The 10Print algorithm, based on
// 03-Canvas-Explore / CanvasAnimView.swift
//
// Difference from the sample: the sample animates, adding one slash every
// tenth of a second with TimelineView. Here the whole picture is built up
// front into an array of tiles, and the Shuffle button makes a new array.

let ncols = 10
let nrows = 16
let lineWidth = 8.0
let colorSpecs = [Color.red, Color.green, Color.yellow, Color.blue, Color.black]

// One cell of the grid: which way the slash leans, and what color it is
struct Tile {
  var isForwardSlash: Bool
  var color: Color
}

// Build a fresh array of random tiles -- this is the "random elements" part
func makeTiles() -> [Tile] {
  var result: [Tile] = []
  for _ in 0..<(ncols * nrows) {
    let tile = Tile(isForwardSlash: Bool.random(),
                    color: colorSpecs.randomElement()!)
    result.append(tile)
  }
  return result
}

struct TenPrintView: View {
  // @State so that tapping Shuffle redraws the Canvas
  // @State introduced in 03-Counts-UI
  @State var tiles = makeTiles()

  var body: some View {
    VStack {
      Text("10 Print")
        .font(.title)

      Canvas { context, size in
        // square cells, sized to fit ncols across
        let cellw = size.width / Double(ncols)
        let cellh = cellw

        for i in 0..<tiles.count {
          let col = i % ncols
          let row = i / ncols
          let x = Double(col) * cellw
          let y = Double(row) * cellh
          let tile = tiles[i]

          var path = Path()
          if tile.isForwardSlash {
            // top left to bottom right
            path.move(to: CGPoint(x: x, y: y))
            path.addLine(to: CGPoint(x: x + cellw, y: y + cellh))
          }
          else {
            // top right to bottom left
            path.move(to: CGPoint(x: x + cellw, y: y))
            path.addLine(to: CGPoint(x: x, y: y + cellh))
          }

          let style = StrokeStyle(lineWidth: lineWidth, lineCap: .round)
          context.stroke(path, with: .color(tile.color), style: style)
        }
      }

      Button("Shuffle") {
        tiles = makeTiles()
      }
      .font(.title2)
      .padding()
    }
  }
}

#Preview {
  TenPrintView()
}
