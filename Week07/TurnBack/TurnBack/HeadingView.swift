//
//  HeadingView.swift
//  TurnBack - Week07 homework, Jackie Nam
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
//  Week07: before marking, add a photo of the view you are facing. "Face the
//  way you marked" was the weak spot in Week06 - by the time I got back I only
//  roughly remembered which way that was. Now the photo is on screen while
//  walking, so I can line up with it before saving, and it is kept with the
//  walk in My Walks. PhotosPicker and loadImage are from the class sample
//  07-Instafilter.
//

import PhotosUI
import SwiftUI

struct HeadingView: View {
  @Environment(MotionDetector.self) var detector
  @Environment(Document.self) var document

  @State var markedYaw = 0.0
  @State var isMarked = false
  @State var markedDate = Date()
  @State var savedMessage = ""

  // Week07: the photo of the way I am facing. selectedItem is what
  // PhotosPicker hands back; loadImage turns it into pickedImage.
  // Same pair as processedImage / selectedItem in 07-Instafilter.
  @State var selectedItem: PhotosPickerItem?
  @State var pickedImage: UIImage?

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
        // Week07: the photo goes right above the save button - it is what to
        // line up with before tapping it.
        if let pickedImage {
          Image(uiImage: pickedImage)
            .resizable()
            .scaledToFit()
            .frame(maxHeight: 120)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .padding(.horizontal)
        }

        Text(
          pickedImage == nil
            ? "Back where you started? Face the way you marked, then save."
            : "Back where you started? Line up with your photo, then save."
        )
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
        // Week07: PhotosPicker opens the photo library. It can't take a new
        // photo, so take one with the Camera app first, then pick it here.
        // matching: .images leaves videos out of the list.
        PhotosPicker(selection: $selectedItem, matching: .images) {
          HStack(spacing: 12) {
            if let pickedImage {
              Image(uiImage: pickedImage)
                .resizable()
                .scaledToFill()
                .frame(width: 44, height: 44)
                .clipShape(RoundedRectangle(cornerRadius: 8))
              Text("Change photo")
            } else {
              Image(systemName: "photo.badge.plus")
                .font(.title2)
              Text("Add a photo of this view")
            }
          }
          .font(.headline)
          .frame(maxWidth: .infinity, minHeight: 56)
          .background(
            RoundedRectangle(cornerRadius: 14)
              .foregroundStyle(Color.gray.opacity(0.1)))
        }
        .onChange(of: selectedItem, loadImage)
        .padding(.horizontal)
        .padding(.bottom, 12)

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

  // From loadImage in 07-Instafilter, without the Core Image filter part.
  // Task and await are there because getting the photo out of the library
  // can take a moment - the sample does it this way and so do I.
  func loadImage() {
    Task {
      guard let imageData = try? await selectedItem?.loadTransferable(type: Data.self) else { return }
      guard let inputImage = UIImage(data: imageData) else { return }
      pickedImage = inputImage
    }
  }

  // Week06: save one entry to the drift log, then go back to unmarked.
  // timeIntervalSince gives seconds, so divide by 60 for minutes.
  // Week07: if there is a photo, save it as its own file first. A new UUID
  // makes a file name that can't clash with another walk's photo.
  func saveDrift() {
    let degrees = turnAngle * 180 / Double.pi
    var photoFile: String?
    if let pickedImage {
      let fileName = UUID().uuidString + ".jpg"
      document.savePhoto(image: pickedImage, fileName: fileName)
      photoFile = fileName
    }
    let entry = DriftEntry(
      emoji: emojis[nameIndex],
      name: names[nameIndex],
      date: Date(),
      minutes: Date().timeIntervalSince(markedDate) / 60,
      driftDegrees: degrees,
      photoFile: photoFile)
    document.addEntry(entry: entry)
    isMarked = false
    // The next walk starts without a photo.
    pickedImage = nil
    selectedItem = nil
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
