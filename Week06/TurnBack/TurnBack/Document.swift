//
//  Document.swift
//  TurnBack - Week06 homework, Jackie Nam
//
//  The drift log the whole app shares. Made once in TurnBackApp and passed down
//  with .environment, the same way the MotionDetector is. From Document.swift
//  in the class sample 06-ImageEditDemoJSON.
//
//  Every change is saved straight away, so there is no Save button to forget.
//

import Foundation

@Observable
class Document {
  var model: Model

  // The file lives in the app's Documents folder. saveJSON prints a cp command
  // in the Xcode console that copies it to Downloads, to look at it.
  let saveFileName = "driftlog.json"

  init() {
    // For testing - uncomment to start over with an empty log:
    // remove(fileName: saveFileName)
    model = Model(JSONfileName: saveFileName)
  }

  func addEntry(entry: DriftEntry) {
    model.entries.append(entry)
    saveModel()
  }

  func clearAll() {
    model.entries = []
    saveModel()
  }

  func saveModel() {
    print("Document saveModel")
    model.saveAsJSON(fileName: saveFileName)
  }
}
