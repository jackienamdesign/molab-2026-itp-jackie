//
//  BrowseView.swift
//  TurnBack - Week05 homework, Jackie Nam
//
//  The list of pages. Copied from SeismometerBrowser in the class sample
//  05-Seismometer, with NavigationStack instead of NavigationSplitView - the
//  split view is really for iPad, and on a phone a stack is the Week03
//  NavigationView / NavigationLink idea in its current form.
//
//  The detector is started and stopped here, for the whole app, exactly like
//  SeismometerBrowser does it.
//

import SwiftUI

struct BrowseView: View {
  @Environment(MotionDetector.self) var detector

  var body: some View {
    NavigationStack {
      List {
        NavigationLink(destination: HeadingView()) {
          HStack {
            Image(systemName: "location.north.fill")
              .foregroundColor(Color.accentColor)
              .padding()
              .font(.title2)

            VStack(alignment: .leading, spacing: 8) {
              Text("Heading")
                .font(.headline)
              Text("Mark the way you are facing, then follow the arrow back to it.")
                .font(.caption)
            }
            .padding(.trailing)
          }
        }
        .padding([.top, .bottom])

        NavigationLink(destination: LevelView()) {
          HStack {
            Image(systemName: "level")
              .foregroundColor(Color.accentColor)
              .padding()
              .font(.title2)

            VStack(alignment: .leading, spacing: 8) {
              Text("Level")
                .font(.headline)
              Text("Check that the phone is flat, so the heading is honest.")
                .font(.caption)
            }
            .padding(.trailing)
          }
        }
        .padding([.top, .bottom])

        NavigationLink(destination: AboutView()) {
          HStack {
            Image(systemName: "info.circle")
              .foregroundColor(Color.accentColor)
              .padding()
              .font(.title2)

            VStack(alignment: .leading, spacing: 8) {
              Text("About")
                .font(.headline)
              Text("What the gyroscope can and cannot tell you.")
                .font(.caption)
            }
            .padding(.trailing)
          }
        }
        .padding([.top, .bottom])
      }
      .listStyle(.plain)
      .navigationTitle(Text("TurnBack"))
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
  BrowseView()
    .environment(MotionDetector(updateInterval: 0.1).started())
}
