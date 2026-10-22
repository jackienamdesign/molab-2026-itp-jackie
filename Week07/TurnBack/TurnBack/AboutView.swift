//
//  AboutView.swift
//  TurnBack - Week07 homework, Jackie Nam
//
//  Week07 UX pass: left-aligned with short headings instead of centered
//  paragraphs in small type - centered text is hard to read past one line.
//  The text is kept short enough to fit without scrolling.
//

import SwiftUI

struct AboutView: View {
  var body: some View {
    VStack(alignment: .leading, spacing: 14) {
      HStack(spacing: 12) {
        Image(systemName: "location.north.fill")
          .font(.title)
          .foregroundStyle(Color.accentColor)
        Text("TurnBack")
          .font(.largeTitle)
          .fontWeight(.bold)
      }

      Text("Mark the way you came in, wander off, and the arrow points you back.")

      Text("How to use it")
        .font(.headline)
        .padding(.top, 6)
      Text("1. Take a photo of the view you are facing.\n"
        + "2. Pick what the spot is, then tap Mark.\n"
        + "3. Walk. Back at the spot, line up with the photo and tap I'm back.")
        .font(.callout)

      Text("This is not a compass")
        .font(.headline)
        .padding(.top, 6)
      Text("The gyroscope only knows how far the phone has turned since the app "
        + "started, not where north is. So the direction has to be marked again "
        + "every launch. Hold the phone flat - tilting it throws the arrow off.")
        .font(.callout)

      Text("Why My Walks")
        .font(.headline)
        .padding(.top, 6)
      Text("The heading can't be saved, but how far it drifts can. Every walk is "
        + "kept on the phone, so you can see how much the gyroscope wanders.")
        .font(.callout)

      Spacer()

      Text("Jackie Nam, ITP Mobile Lab 2026. MotionDetector and the level are from "
        + "05-BubbleLevel, saving from 06-ImageEditDemoJSON, photos from "
        + "07-Instafilter and 07-PhotoPickBlender.")
        .font(.caption)
        .foregroundStyle(Color.secondary)
    }
    .padding()
    .frame(maxWidth: .infinity, alignment: .leading)
    .navigationTitle("About")
    .navigationBarTitleDisplayMode(.inline)
  }
}

#Preview {
  NavigationStack {
    AboutView()
  }
}
