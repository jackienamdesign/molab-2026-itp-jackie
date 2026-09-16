//: Loading and displaying ascii art from app bundle

import Foundation

// Create text file and copy and paste to add - avoids string quoting requirements

// Load and print one file from Resource bundle
let path = Bundle.main.path(forResource: "aardvark.txt", ofType: nil)
let str = try String(contentsOfFile: path!, encoding: .utf8)
print(str)

// same as a function
func load(_ file :String) -> String {
  let path = Bundle.main.path(forResource: file, ofType: nil)
  let str = try? String(contentsOfFile: path!, encoding: .utf8)
//  return str! -- will crash if str is nil
  return str ?? "" // will return "" if str is nil
}

print(load("bat.txt"))

print(load("cat.txt"))

print(load("elephant.txt"))

//: [Previous](@previous)  [Next](@next)

// Source:
// https://asciiart.website/index.php?art=animals/aardvarks
