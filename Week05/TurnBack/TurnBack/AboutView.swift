//
//  AboutView.swift
//  TurnBack - Week05 homework, Jackie Nam
//

import SwiftUI

struct AboutView: View {
  var body: some View {
    VStack {
      Image(systemName: "location.north.fill")
        .font(.largeTitle)
        .foregroundStyle(Color.accentColor)
        .padding()

      Text("TurnBack")
        .font(.title)

      Text(
        "Mark the direction you are facing before you wander off. "
          + "The arrow keeps pointing back that way, so you can find your way "
          + "out the way you came in."
      )
      .multilineTextAlignment(.center)
      .padding()

      Text("This is not a compass")
        .font(.headline)
        .padding(.top)

      Text(
        "The gyroscope only knows how far the phone has spun since the app "
          + "started. It has no idea where north is - that needs the "
          + "magnetometer, which we have not covered. So the arrow is relative "
          + "to wherever you were standing when you pressed Mark, and it has to "
          + "be marked again every time the app is relaunched."
      )
      .font(.caption)
      .multilineTextAlignment(.center)
      .padding()

      Spacer()

      Text("Jackie Nam, ITP Mobile Lab 2026")
        .font(.caption)
      Text("MotionDetector and the bubble level are from the class sample 05-BubbleLevel")
        .font(.caption)
        .multilineTextAlignment(.center)
        .padding()
    }
    .padding()
    .navigationTitle("About")
  }
}

#Preview {
  AboutView()
}
