//: cows sorted using tuples to remember original order

import Foundation

let path = URL(string: "https://raw.githubusercontent.com/sindresorhus/cows/main/cows.txt")
let cowsStr = try String(contentsOf: path!, encoding: .utf8)
print("cowsStr.count \(cowsStr.count)")

let components = cowsStr.components(separatedBy: "\n\n\n")
print("components.count", components.count)

for (index, value) in components.enumerated() {
  if index < 2 {
    print("for index", index)
    print(value)
    print("----")
  }
}

let tuples = Array(components.enumerated())
//print("tuples", tuples)
print("----\n examine tuples[0] \n \(tuples[0]) \n----")
print("----\n examine tuples[9] \n \(tuples[9]) \n----")

let sorted = tuples.sorted { $0.element.count < $1.element.count }

let n = min(sorted.count, 10)
for index in 0..<n {
  let tup = sorted[index]
  print("sorted index", index, "offset", tup.offset)
  print(tup.element)
}

//: [Previous](@previous)  [Next](@next)
