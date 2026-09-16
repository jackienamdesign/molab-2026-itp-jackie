# Week02 — Swift Programming 2, Anatomy of an iOS App (2026-09-10)

Syllabus page: [weeks/02_swift.md](https://github.com/molab-itp/content-2026-itp/blob/main/weeks/02_swift.md)

Sample code from the teacher ("new stuff" this week):

- [02-Ascii-Play](https://github.com/molab-itp/02-Ascii-Play) — ascii animals
- [01-UIRender-playground](https://github.com/molab-itp/01-UIRender-playground) — rendering unicode and system images
- [02-Icon-Image](https://github.com/molab-itp/02-Icon-Image) — SwiftUI in a playground (demoed, not required)

Sample pages are copied into `02-Ascii-Play.playground` unmodified. Leave them alone —
Jackie's own work goes in new pages. The `ascii image` page is hers.

## Assignment — Option 1 (the one being done)

Create an Xcode playground that **creates an image using ascii text**, based on the
techniques demonstrated in `02-Ascii-Play`.

(Option 2, not taken: a 1024x1024 image based on `01-UIRender-playground`.)

This combines strings from `02-Ascii-Play` with drawing from `01-UIRender-playground`.
Both are Week 02 material, so both vocabularies below are fair game, along with
everything from [Week01](../Week01/CLAUDE.md).

## Covered this week — use only these

Everything from Week01, plus:

### Loading text — from `02-Ascii-Play`

- From the playground bundle: `Bundle.main.path(forResource:ofType:)` then
  `String(contentsOfFile:encoding:)`
- From a URL: `String(contentsOf: url, encoding: .utf8)`
- The `load(_ file: String) -> String` helper from the `inter weave` pages

### Strings into arrays — from `02-Ascii-Play`

- `str.split(separator: "\n")` → `Array<Substring>`
- `str.components(separatedBy: "\n\n\n")` → `Array<String>`
- `arr.joined(separator: "\n")`
- `String(repeating: " ", count: n)` for padding
- `String(substring)` to convert back
- `arr.append(item)`, `arr[index]`, `0..<arr.count`
- `var arr: Array<String> = []`

### Array operations — from `02-Ascii-Play`

Trailing closure syntax with `$0` shorthand, as the samples use:

- `arr.map { $0.count }`
- `arr.filter { $0.count < 100 }`
- `arr.sorted { $0.count < $1.count }`
- `arr.max()`, `arr.min()`, `min(a, b)`
- `arr.randomElement()`
- Tuples — `(count, index)` pairs to remember original order

### Drawing — from `01-UIRender-playground`

Requires `import UIKit` and `target-platform='ios'`.

- `UIGraphicsImageRenderer(size:)` and `renderer.image { context in ... }`
- `renderer.format.bounds`
- `UIColor.red.setFill()` / `.setStroke()`, then `context.fill(rect)` / `context.stroke(rect)`
- `UIColor(red:green:blue:alpha:)`
- `CGSize`, `CGPoint`, `CGRect`, `rect.insetBy(dx:dy:)`
- `UIFont.systemFont(ofSize:)`, `NSAttributedString(string:attributes:)`, `.draw(at:)`
- `UIImage(systemName:)` for SF Symbols, `.withTintColor()`, `.draw(in:)`
- Loading an image from a URL: `Data(contentsOf:)` + `UIImage(data:)`
- Raw Core Graphics via `context.cgContext` — `move(to:)`, `addLine(to:)`,
  `drawPath(using:)`, `setLineCap()`, `setLineWidth()`, `setStrokeColor()`
- `Bool.random()`
- Saving: `image.pngData()`, then
  `FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)` and
  `data.write(to:)`

## Not yet — Week 03 material

**SwiftUI is Week 03.** `02-Icon-Image` was demoed in class but SwiftUI is not formally
introduced until 2026-09-17. Do not suggest `View`, `@State`, `Canvas`, `ZStack`, or
`ImageRenderer` for this assignment. Use `UIGraphicsImageRenderer`.

## Gotchas worth knowing

- ASCII art needs a **monospaced** font or the character grid shears apart:
  `UIFont.monospacedSystemFont(ofSize:weight:)`
- `NSAttributedString.draw(at:)` draws one line only. Multi-line text needs
  `.draw(in: someRect)`.
- `02-Ascii-Play.playground` is `target-platform='ios'`, which is what UIKit needs.
