# Week01 — Swift Programming 1, Introduction (2026-09-03)

Syllabus page: [weeks/01_intro.md](https://github.com/molab-itp/content-2026-itp/blob/main/weeks/01_intro.md)

Sample code from the teacher:

- [01-Playground](https://github.com/molab-itp/01-Playground)
- [01-Javascript-to-Swift](https://github.com/molab-itp/01-Javascript-to-Swift)

## Assignment

Create a playground that produces **text art**, demonstrating use of variables,
for-loops, and functions. Model: the `generative random` page in `01-Playground`.

## Covered this week — use only these

Plain Swift with `import Foundation`. **No UIKit, no SwiftUI, no drawing.** This week
is text printed to the console.

**Values**

- `let` / `var`
- `String`, `Int`, `Double`, `Bool`
- String concatenation with `+` and `+=`
- String interpolation: `"text \(value)"`
- `str.count`
- Indexing into a string: `str.index(str.startIndex, offsetBy: n)`, then `str[index]`
- `String(char)` to convert a `Character` back to a `String`

**Control flow**

- `for _ in 0..<n { }`
- `if` / `else`
- `print(...)`

**Functions**

- `func name(_ label: Type) -> Type { }` — underscore for unnamed argument labels
- Functions with no return value
- Calling one function from inside another (`generateBlock` calls `generateLine`)

**Randomness**

- `Int.random(in: 0..<n)`

## Notes

- `MyPlayground.playground` is set to `target-platform='macos'` with `display-mode='raw'`.
  That is correct for this week — Foundation only, no UIKit needed.
- Emoji are multi-byte, which is why the samples use `charAt`-style index helpers
  instead of subscripting by integer. Swift strings are not arrays of characters.
