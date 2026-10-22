//
//  ContentView.swift
//  TurnBack - Week07 homework, Jackie Nam
//
//  Week07 UX pass: the app opens straight on Way Back. Before, it opened on a
//  menu of four pages that all looked equally important, and the one I open
//  the app for was a tap away. Now there are three tabs - the TabView from
//  Week03 / 03-About-Me, same as Week04's MinuteGarden.
//
//  Level is no longer its own page in the menu. Way Back shows a warning when
//  the phone isn't flat, and tapping it opens the Level.
//
//  Each tab gets its own NavigationStack so its title shows, and My Walks can
//  open a walk's detail page.
//
//  The detector is started and stopped here, for the whole app - this used to
//  be in BrowseView, from SeismometerBrowser in 05-Seismometer.
//

import SwiftUI

struct ContentView: View {
  @Environment(MotionDetector.self) var detector

  var body: some View {
    TabView {
      NavigationStack {
        HeadingView()
      }
      .tabItem {
        Label("Way Back", systemImage: "location.north.fill")
      }

      NavigationStack {
        LogView()
      }
      .tabItem {
        Label("My Walks", systemImage: "figure.walk")
      }

      NavigationStack {
        AboutView()
      }
      .tabItem {
        Label("About", systemImage: "info.circle")
      }
    }
    .onAppear {
      detector.start()
    }
    .onDisappear {
      detector.stop()
    }
  }
}

#Preview {
  ContentView()
    .environment(MotionDetector(updateInterval: 0.1).started())
    .environment(Document())
}
