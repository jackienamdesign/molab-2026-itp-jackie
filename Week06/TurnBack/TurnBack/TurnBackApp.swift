//
//  TurnBackApp.swift
//  TurnBack - Week06 homework, Jackie Nam
//
//  One MotionDetector is made here and handed to every page with .environment,
//  the same way SeismometerApp and BubbleLevelApp do it.
//

import SwiftUI

@main
struct TurnBackApp: App {
  // The samples use 0.01 seconds. 0.1 is ten times a second, which is plenty
  // for an arrow you are walking behind, and it shakes around less.
  @State var detector = MotionDetector(updateInterval: 0.1)

  // Week06: the drift log, loaded from driftlog.json. Shared the same way as
  // the detector, like ImageDemoApp in 06-ImageEditDemoJSON.
  @State var document = Document()

  var body: some Scene {
    WindowGroup {
      BrowseView()
        .environment(detector)
        .environment(document)
    }
  }
}
