//
//  Model.swift
//  TurnBack - Week06 homework, Jackie Nam
//
//  Everything that gets written to the JSON file: just the list of entries.
//  From Model.swift and ModelJSON.swift in the class sample 06-ImageEditDemoJSON,
//  put in one file. saveJSON and loadJSON come from SaveLoadJSON.swift, copied
//  from the same sample.
//

import Foundation

struct Model: Codable {
  var entries: [DriftEntry]

  // Start empty, then try the file. The first time the app runs there is no
  // file yet, so loadJSON throws and we keep the empty list.
  init(JSONfileName fileName: String) {
    entries = []
    do {
      self = try loadJSON(Model.self, fileName: fileName)
    } catch {
      print("Model init JSONfileName error \(error)")
    }
  }

  func saveAsJSON(fileName: String) {
    do {
      try saveJSON(fileName: fileName, val: self)
    } catch {
      fatalError("Model saveAsJSON error \(error)")
    }
  }
}
