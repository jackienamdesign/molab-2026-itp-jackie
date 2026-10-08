//
//  HeadingView.swift
//  TurnBack - Week05 homework, Jackie Nam
//
//  The arrow page. Press Mark and the app remembers the direction the phone is
//  pointing. Walk around, and the arrow keeps pointing back that way.
//
//  detector.yaw is how far the phone has spun since the sensor started, in
//  radians. The arrow is turned with .rotationEffect, the same trick the needle
//  in 05-Seismometer / NeedleSeismometer uses.
//

import SwiftUI

struct HeadingView: View {
  @Environment(MotionDetector.self) var detector

  @State var markedYaw = 0.0
  @State var isMarked = false

  // @AppStorage remembers which place is picked between launches - new this
  // week, from the class sample 05-AppStorageDemo.
  @AppStorage("nameIndex") var nameIndex = 0

  // The two arrays line up: emojis[i] is the button for names[i].
  // Emoji are text, not symbols, so they go in a Text - same as Week03 /
  // EmojiGridView.
  let emojis = ["📍", "🏠", "🚗", "🥾"]
  let names = ["my start", "home", "the car", "the trailhead"]

  var markName: String {
    names[nameIndex]
  }

  // How far the phone has turned away from the marked direction.
  // yaw wraps around at -pi and pi, so the difference can come out bigger than
  // half a turn. These two ifs bring it back into -pi...pi.
  var turnAngle: Double {
    var diff = detector.yaw - markedYaw
    if diff > Double.pi {
      diff = diff - 2 * Double.pi
    }
    if diff < -Double.pi {
      diff = diff + 2 * Double.pi
    }
    return diff
  }

  var degreesString: String {
    let degrees = turnAngle * 180 / Double.pi
    return degrees.describeAsFixedLengthString(
      integerDigits: 3, fractionDigits: 0)
  }

  var body: some View {
    VStack {
      Text(isMarked ? "Back to " + markName : "Face " + markName + " and mark it")
        .font(.title2)
        .multilineTextAlignment(.center)
        .padding()

      Image(systemName: "location.north.fill")
        .resizable()
        .scaledToFit()
        .frame(width: 160, height: 160)
        .foregroundStyle(isMarked ? Color.accentColor : Color.gray)
        .rotationEffect(Angle(radians: turnAngle))
        .padding(40)

      Text(degreesString + "\u{00B0}")
        .font(.system(.largeTitle, design: .monospaced))

      Text(isMarked ? "turned from " + markName : "nothing marked yet")
        .font(.caption)
        .foregroundStyle(Color.secondary)

      Spacer()

      // One button per place. Tapping one picks it; the others fade back.
      HStack {
        ForEach(0..<emojis.count, id: \.self) { i in
          Button(action: { nameIndex = i }) {
            Text(emojis[i])
              .font(.system(size: 40))
              .padding(10)
              .opacity(nameIndex == i ? 1.0 : 0.3)
              .background(
                Circle()
                  .foregroundStyle(
                    nameIndex == i
                      ? Color.accentColor.opacity(0.2) : Color.clear)
              )
          }
        }
      }
      .padding(.bottom)

      Button("Mark " + markName) {
        mark()
      }
      .font(.title3)
      .padding(.bottom)
    }
    .navigationTitle("Heading")
  }

  func mark() {
    markedYaw = detector.yaw
    isMarked = true
  }
}

#Preview {
  HeadingView()
    .environment(MotionDetector(updateInterval: 0.1).started())
}
