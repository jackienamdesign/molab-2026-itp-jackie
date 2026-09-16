//: cow for loops

import Foundation

let path = URL(string: "https://raw.githubusercontent.com/sindresorhus/cows/main/cows.txt")
let cowsStr = try String(contentsOf: path!, encoding: .utf8)
print("cowsStr.count", cowsStr.count)

// https://github.com/sindresorhus/cows/blob/main/index.js
//  module.exports = () => fs.readFileSync(path.join(__dirname, 'cows.txt'), 'utf8')
//    .replace(/\n$/, '').split('\n\n\n');

//let cowsSplit = cowsStr.split(separator: "\n", omittingEmptySubsequences: false)
let cowsSplit = cowsStr.split(separator: "\n\n\n", omittingEmptySubsequences: false)
print("cowsSplit.count \(cowsSplit.count)")

// show first 3 cows
print("first few cows")
for index in 0...3 {
  let it = cowsSplit[index]
//  print("\(it) \(it.count) \(index)")
  print("count \(it.count) index \(index) \n\(it)\n----")
}

//: [Previous](@previous)  [Next](@next)
