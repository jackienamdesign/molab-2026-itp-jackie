//
//  HeadingView.swift
//  TurnBack - Week06 homework, Jackie Nam
//
//  The "Way Back" page. Press Mark and the app remembers the direction the
//  phone is pointing. Walk around, and the arrow keeps pointing back that way.
//
//  detector.yaw is how far the phone has spun since the sensor started, in
//  radians. The arrow is turned with .rotationEffect, the same trick the needle
//  in 05-Seismometer / NeedleSeismometer uses.
//
//  Week06: once you are back at the spot, face the way you marked and tap
//  I'm back. Whatever the arrow reads then is how far the gyroscope drifted,
//  and that gets saved to My Walks.
//
//  Week06 UX pass: the screen shows only what matters for the step you are on.
//  Before marking: pick the place, then one big Mark button. While walking: the
//  arrow, which way to turn in words, and one big I'm back button. Every button
//  is at least 44 points tall, Apple's minimum touch target.
//

import SwiftUI

struct HeadingView: View {
  @Environment(MotionDetector.self) var detector
  @Environment(Document.self) var document

  @State var markedYaw = 0.0
  @State var isMarked = false
  @State var markedDate = Date()
  @State var savedMessage = ""

  // @AppStorage remembers which place is picked between launches - new this
  // week, from the class sample 05-AppStorageDemo.
  @AppStorage("nameIndex") var nameIndex = 0

  // The three arrays line up: emojis[i] and labels[i] are the button for
  // names[i]. labels are short for under the emoji; names read in a sentence.
  // Emoji are text, not symbols, so they go in a Text - same as Week03 /
  // EmojiGridView.
  let emojis = ["📍", "🏠", "🚗", "🥾"]
  let labels = ["Start", "Home", "Car", "Trail"]
  let names = ["the start", "home", "the car", "the trailhead"]

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

  // The angle in words, so nobody has to work out what a minus sign means.
  // A positive angle turns the arrow clockwise, so the way back is to the
  // right. Under 3 degrees counts as straight ahead - the sensor jitters.
  var turnText: String {
    let degrees = Int(abs(turnAngle * 180 / Double.pi))
    if degrees < 3 {
      return "Straight ahead"
    }
    if turnAngle > 0 {
      return String(degrees) + "\u{00B0} to your right"
    }
    return String(degrees) + "\u{00B0} to your left"
  }

  var body: some View {
    VStack {
      Text(isMarked ? "Follow the arrow back to " + markName : "Face the way you came from")
        .font(.title2)
        .fontWeight(.semibold)
        .multilineTextAlignment(.center)
        .padding(.horizontal)
        .padding(.top)

      Spacer()

      // Grey until something is marked, so it doesn't look like it's pointing
      // somewhere it isn't.
      Image(systemName: "location.north.fill")
        .resizable()
        .scaledToFit()
        .frame(width: 140, height: 140)
        .foregroundStyle(isMarked ? Color.accentColor : Color.gray.opacity(0.4))
        .rotationEffect(Angle(radians: turnAngle))
        .padding(32)

      Text(isMarked ? turnText : "Not marked yet")
        .font(.title)
        .fontWeight(.semibold)

      Text(savedMessage)
        .font(.callout)
        .foregroundStyle(Color.accentColor)
        .padding(.top, 8)

      Spacer()

      if isMarked {
        Text("Back where you started? Face the way you marked, then save.")
          .font(.callout)
          .foregroundStyle(Color.secondary)
          .multilineTextAlignment(.center)
          .padding(.horizontal)

        Button(action: { saveDrift() }) {
          Text("I'm back - save walk")
            .font(.headline)
            .foregroundStyle(Color.white)
            .frame(maxWidth: .infinity, minHeight: 56)
            .background(
              RoundedRectangle(cornerRadius: 16)
                .foregroundStyle(Color.accentColor))
        }
        .padding(.horizontal)

        // Kept small and well below the main button so it is hard to hit by
        // accident - it throws the walk away. contentShape makes the whole
        // 44 point strip tappable, not just the letters.
        Button(action: { cancelMark() }) {
          Text("Start over")
            .foregroundStyle(Color.secondary)
            .frame(maxWidth: .infinity, minHeight: 44)
            .contentShape(Rectangle())
        }
        .padding(.top, 12)
        .padding(.bottom)
      } else {
        Text("This spot is")
          .font(.callout)
          .foregroundStyle(Color.secondary)

        // One button per place. Each is a full tile with a word under the
        // emoji, so it is easy to hit and clear what it means.
        HStack(spacing: 10) {
          ForEach(0..<emojis.count, id: \.self) { i in
            Button(action: { nameIndex = i }) {
              VStack(spacing: 4) {
                Text(emojis[i])
                  .font(.system(size: 32))
                  .opacity(nameIndex == i ? 1.0 : 0.5)
                Text(labels[i])
                  .font(.caption)
                  .fontWeight(nameIndex == i ? .semibold : .regular)
                  .foregroundStyle(nameIndex == i ? Color.primary : Color.secondary)
              }
              .frame(maxWidth: .infinity, minHeight: 72)
              .background(
                RoundedRectangle(cornerRadius: 14)
                  .foregroundStyle(
                    nameIndex == i
                      ? Color.accentColor.opacity(0.18) : Color.gray.opacity(0.1))
              )
            }
          }
        }
        .padding(.horizontal)
        .padding(.bottom, 12)

        Button(action: { mark() }) {
          Text("Mark this direction")
            .font(.headline)
            .foregroundStyle(Color.white)
            .frame(maxWidth: .infinity, minHeight: 56)
            .background(
              RoundedRectangle(cornerRadius: 16)
                .foregroundStyle(Color.accentColor))
        }
        .padding(.horizontal)
        .padding(.bottom)
      }
    }
    .navigationTitle("Way Back")
    .navigationBarTitleDisplayMode(.inline)
  }

  func mark() {
    markedYaw = detector.yaw
    markedDate = Date()
    isMarked = true
    savedMessage = ""
  }

  func cancelMark() {
    isMarked = false
    savedMessage = ""
  }

  // Week06: save one entry to the drift log, then go back to unmarked.
  // timeIntervalSince gives seconds, so divide by 60 for minutes.
  func saveDrift() {
    let degrees = turnAngle * 180 / Double.pi
    let entry = DriftEntry(
      emoji: emojis[nameIndex],
      name: names[nameIndex],
      date: Date(),
      minutes: Date().timeIntervalSince(markedDate) / 60,
      driftDegrees: degrees)
    document.addEntry(entry: entry)
    isMarked = false
    savedMessage = "Saved to My Walks - " + String(Int(abs(degrees))) + "\u{00B0} off"
  }
}

#Preview {
  NavigationStack {
    HeadingView()
  }
  .environment(MotionDetector(updateInterval: 0.1).started())
  .environment(Document())
}
