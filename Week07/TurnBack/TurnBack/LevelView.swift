/*
See the License.txt file for this sample’s licensing information.
*/

//
//  LevelView.swift - from the class sample 05-BubbleLevel
//  TurnBack - Week07 homework, Jackie Nam
//
//  Week07 UX pass: the sample shows roll and pitch as raw numbers in radians.
//  What I actually want to know is "is the phone flat enough?", so the answer
//  is now a yes or no at the top, and the numbers are small underneath.
//
//  Flat enough = tilted less than 10 degrees either way. HeadingView uses the
//  same test for its "not flat" warning.
//

import SwiftUI

struct LevelView: View {
  @Environment(MotionDetector.self) var motionDetector: MotionDetector

  // How far from flat, in degrees - whichever of roll or pitch is worse.
  var tiltDegrees: Int {
    let worst = max(abs(motionDetector.roll), abs(motionDetector.pitch))
    return Int(worst * 180 / Double.pi)
  }

  var isFlat: Bool {
    tiltDegrees < 10
  }

  var body: some View {
    VStack(spacing: 8) {
      Image(systemName: isFlat ? "checkmark.circle.fill" : "exclamationmark.triangle.fill")
        .font(.system(size: 44))
        .foregroundStyle(isFlat ? Color.accentColor : Color.orange)
        .padding(.top)

      Text(isFlat ? "Flat enough" : "Tilted " + String(tiltDegrees) + "\u{00B0}")
        .font(.title)
        .fontWeight(.semibold)

      Text(isFlat
        ? "Keep the phone like this and the arrow stays honest."
        : "Tip the phone until the dot sits in the middle.")
        .font(.callout)
        .foregroundStyle(Color.secondary)
        .multilineTextAlignment(.center)
        .padding(.horizontal)

      Spacer()

      BubbleLevel()

      Spacer()

      OrientationDataView()
        .foregroundStyle(Color.secondary)
        .padding(.bottom)
    }
    .navigationTitle("Level")
    .navigationBarTitleDisplayMode(.inline)
  }
}

#Preview {
  NavigationStack {
    LevelView()
  }
  .environment(MotionDetector(updateInterval: 0.1).started())
}
