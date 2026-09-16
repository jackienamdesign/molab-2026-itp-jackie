import UIKit

func load(_ file: String) -> String {
    let path = Bundle.main.path(forResource: file, ofType: nil)
    let str = try? String(contentsOfFile: path!, encoding: .utf8)
    return str!
}

let part1 = load("elephant.txt")
let part2 = load("cat.txt")

let part1Split = part1.split(separator: "\n")
let part2Split = part2.split(separator: "\n")

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

print(lines.joined(separator: "\n"))

let fontSize = 32.0
let font = UIFont.monospacedSystemFont(ofSize: fontSize, weight: .regular)

let charWidth = fontSize * 0.6
let lineGap = fontSize * 1.2

let widest = lines.map { $0.count }.max()!

let margin = 40.0
let imageWidth = charWidth * Double(widest) + margin * 2
let imageHeight = lineGap * Double(lines.count) + margin * 2

print("widest \(widest) characters, image \(imageWidth) by \(imageHeight)")

let renderer = UIGraphicsImageRenderer(size: CGSize(width: imageWidth, height: imageHeight))

let image = renderer.image { context in

    UIColor.white.setFill()
    context.fill(renderer.format.bounds)

    for index in 0..<lines.count {
        let str = NSAttributedString(string: lines[index], attributes: [.font: font])
        let y = margin + lineGap * Double(index)
        str.draw(at: CGPoint(x: margin, y: y))
    }
}

image

let data = image.pngData()

let folder = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first

let filePath = folder!.appendingPathComponent("ascii-image.png")

let err: ()? = try? data?.write(to: filePath)
print("err \(String(describing: err))")

print("cp \(filePath.absoluteString.dropFirst(7)) ~/Downloads/.")

//: [Previous](@previous)
