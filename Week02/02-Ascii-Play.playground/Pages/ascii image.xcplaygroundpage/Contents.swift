//: Making an image out of ascii text

//: Week02 homework, Option 1:
//: create a playground that makes an image using ascii text,
//: based on the techniques in 02-Ascii-Play.
//:
//: The ascii work is all from the 02-Ascii-Play sample pages.
//: 02-Ascii-Play only prints to the console, so the drawing calls
//: come from the 01-UIRender-playground samples shown the same week.
//:
//: Only ONE thing here is not in a sample page:
//: UIFont.monospacedSystemFont, marked "NOT IN SAMPLES" below.
//: The samples use UIFont.systemFont, but that gives every character
//: a different width, which destroys ascii art. There is no way to draw
//: ascii art correctly without a monospaced font.

import UIKit

//: ## 1. Load the ascii art
//: load() is from the 'inter weave' sample page

func load(_ file: String) -> String {
    let path = Bundle.main.path(forResource: file, ofType: nil)
    let str = try? String(contentsOfFile: path!, encoding: .utf8)
    return str!
}

// elephant is 7 lines, cat is 4 lines
// combine() below only loops over part1, so the taller one has to go first
// or the extra lines get dropped
let part1 = load("elephant.txt")
let part2 = load("cat.txt")

let part1Split = part1.split(separator: "\n")
let part2Split = part2.split(separator: "\n")

//: ## 2. Put the two animals side by side
//: combine() is from the 'inter weave func' sample page

func combine(_ part1: Array<Substring>, _ part2: Array<Substring>, _ margin: Int) -> Array<String> {
    let bmax = part1.map { $0.count }.max()!
    let edge = bmax + margin
    var arr: Array<String> = []
    for index in 0..<part1.count {
        var line1 = part1[index]
        line1 += String(repeating: " ", count: edge - line1.count)
        var line2 = ""
        if index < part2.count {
            line2 = String(part2[index])
        }
        arr.append(line1 + line2)
    }
    return arr
}

let lines = combine(part1Split, part2Split, 6)

// check the text version before drawing it
print(lines.joined(separator: "\n"))

//: ## 3. Work out how big the image needs to be
//: the ascii text decides the size, not the other way round

// NOT IN SAMPLES: monospacedSystemFont
// the renderer sample page uses UIFont.systemFont(ofSize:)
// but in that font every character is a different width,
// so the rows drift apart and the picture falls apart.
// ascii art is a grid and needs every character the same width.
let fontSize = 32.0
let font = UIFont.monospacedSystemFont(ofSize: fontSize, weight: .regular)

// in this monospaced font every character is about 0.6 as wide as the
// font size, and a row of text sits about 1.2 font sizes below the last
let charWidth = fontSize * 0.6
let lineGap = fontSize * 1.2

// the longest line decides how wide the image has to be
// .map and .max() are from the 'inter weave func' sample page
let widest = lines.map { $0.count }.max()!

let margin = 40.0
let imageWidth = charWidth * Double(widest) + margin * 2
let imageHeight = lineGap * Double(lines.count) + margin * 2

print("widest \(widest) characters, image \(imageWidth) by \(imageHeight)")

//: ## 4. Draw it
//: renderer and setFill are from the 01-UIRender-playground samples

let renderer = UIGraphicsImageRenderer(size: CGSize(width: imageWidth, height: imageHeight))

let image = renderer.image { context in

    UIColor.white.setFill()
    context.fill(renderer.format.bounds)

    // draw one line at a time, stepping down the page
    // draw(at:) only draws a single line, so the loop is doing the line breaks
    for index in 0..<lines.count {
        let str = NSAttributedString(string: lines[index], attributes: [.font: font])
        let y = margin + lineGap * Double(index)
        str.draw(at: CGPoint(x: margin, y: y))
    }
}

image

//: ## 5. Save it as a png
//: from the 'save image' sample page

let data = image.pngData()

let folder = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first

// change the file name each run so the newest file sorts to the top
let filePath = folder!.appendingPathComponent("ascii-image.png")

// err is nil if the write failed, Optional(()) if it worked
let err: ()? = try? data?.write(to: filePath)
print("err \(String(describing: err))")

// terminal command to copy the file out to the Downloads folder
print("cp \(filePath.absoluteString.dropFirst(7)) ~/Downloads/.")

//: [Previous](@previous)
