//
//  DriftEntry.swift
//  TurnBack - Week06 homework, Jackie Nam
//
//  One saved walk: where I marked, when, how long I was gone, and how far off
//  the arrow was when I got back. Shaped like ItemModel in the class sample
//  06-ImageEditDemoJSON.
//
//  Codable is what lets this be turned into JSON and back. Every property has
//  to be a type that is Codable too - String, Double, Date and UUID all are.
//

import Foundation

struct DriftEntry: Identifiable, Codable {
  var id = UUID()
  var emoji = ""
  var name = ""
  var date = Date()
  var minutes = 0.0
  var driftDegrees = 0.0
}
