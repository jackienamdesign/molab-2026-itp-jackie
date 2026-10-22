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
//  Week07: before marking, add a photo of the view you are facing. "Face the
//  way you marked" was the weak spot in Week06 - by the time I got back I only
//  roughly remembered which way that was. Now the photo is on screen while
//  walking, so I can line up with it before saving. PhotosPicker and loadImage
//  are from the class sample 07-Instafilter; the in-app camera is
//  CameraPicker.swift.
//
//  Week07 UX pass: the page is two screens in one, picked by isMarked.
//  - markingView: three numbered steps, Photo -> Place -> Mark, in the order
//    you do them. The photo gets the big space at the top - the arrow means
//    nothing until something is marked, so it no longer sits there grey.
//  - walkingView: the arrow is the biggest thing. The photo sits above the
//    I'm back button, and tapping it opens it full screen to line up with.
//  Both show a warning when the phone isn't flat, which used to be hidden on
//  the Level page. Tapping the warning opens Level in a sheet.
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

  // Week07: the in-app camera, CameraPicker.swift. Shown with
  // .fullScreenCover - the sample's .sheet, but filling the screen, which
  // suits a camera better. No camera in the simulator, so the button hides.
  @State var showingCamera = false
  let cameraAvailable = UIImagePickerController.isSourceTypeAvailable(.camera)

  // Week07 UX: the photo full screen, and the Level page in a sheet.
  @State var showingPhoto = false
  @State var showingLevel = false

  // @AppStorage remembers which place is picked between launches - from the
  // class sample 05-AppStorageDemo.
  @AppStorage("nameIndex") var nameIndex = 0

  // The three arrays line up: emojis[i] and labels[i] are the button for
  // names[i]. labels are short for under the emoji; names read in a sentence.
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

  // Week07 UX: same flat-enough test as LevelView - less than 10 degrees of
  // tilt either way.
  var isFlat: Bool {
    let worst = max(abs(detector.roll), abs(detector.pitch))
    return worst * 180 / Double.pi < 10
  }

  var body: some View {
    VStack(spacing: 0) {
      if isMarked {
        walkingView
      } else {
        markingView
      }
    }
    .navigationTitle("Way Back")
    .navigationBarTitleDisplayMode(.inline)
    .fullScreenCover(isPresented: $showingCamera) {
      CameraPicker(image: $pickedImage, isPresented: $showingCamera)
        .ignoresSafeArea()
    }
    .fullScreenCover(isPresented: $showingPhoto) {
      photoFullScreen
    }
    .sheet(isPresented: $showingLevel) {
      NavigationStack {
        LevelView()
      }
    }
  }

  // MARK: before marking - three steps

  var markingView: some View {
    VStack(alignment: .leading, spacing: 10) {
      // After a save, the result shows here until the next Mark.
      if savedMessage != "" {
        HStack(spacing: 8) {
          Image(systemName: "checkmark.circle.fill")
          Text(savedMessage)
        }
        .font(.headline)
        .foregroundStyle(Color.accentColor)
        .frame(maxWidth: .infinity, minHeight: 44)
        .background(
          RoundedRectangle(cornerRadius: 16)
            .foregroundStyle(Color.accentColor.opacity(0.15)))
      }

      Text("1  PHOTO OF THE WAY YOU CAME FROM")
        .font(.caption)
        .fontWeight(.semibold)
        .foregroundStyle(Color.secondary)

      // The photo, or an empty frame saying what goes there.
      // scaledToFill + clipShape fills the frame without stretching.
      ZStack {
        RoundedRectangle(cornerRadius: 16)
          .foregroundStyle(Color.gray.opacity(0.1))
        if let pickedImage {
          Image(uiImage: pickedImage)
            .resizable()
            .scaledToFill()
        } else {
          VStack(spacing: 6) {
            Image(systemName: "photo")
              .font(.system(size: 36))
            Text("Optional - it helps you line up when you get back")
              .font(.caption)
              .multilineTextAlignment(.center)
          }
          .foregroundStyle(Color.secondary)
          .padding()
        }
      }
      .frame(maxWidth: .infinity)
      .frame(height: 180)
      .clipShape(RoundedRectangle(cornerRadius: 16))

      HStack(spacing: 10) {
        if cameraAvailable {
          Button(action: { showingCamera = true }) {
            HStack(spacing: 6) {
              Image(systemName: "camera")
              Text(pickedImage == nil ? "Take photo" : "Retake")
            }
            .font(.subheadline)
            .fontWeight(.semibold)
            .frame(maxWidth: .infinity, minHeight: 44)
            .background(
              RoundedRectangle(cornerRadius: 16)
                .foregroundStyle(Color.gray.opacity(0.1)))
          }
        }

        // matching: .images leaves videos out of the list.
        PhotosPicker(selection: $selectedItem, matching: .images) {
          HStack(spacing: 6) {
            Image(systemName: "photo.on.rectangle")
            Text(cameraAvailable ? "Choose" : "Choose a photo")
          }
          .font(.subheadline)
          .fontWeight(.semibold)
          .frame(maxWidth: .infinity, minHeight: 44)
          .background(
            RoundedRectangle(cornerRadius: 16)
              .foregroundStyle(Color.gray.opacity(0.1)))
        }
        .onChange(of: selectedItem, loadImage)
      }

      Spacer()

      Text("2  THIS SPOT IS")
        .font(.caption)
        .fontWeight(.semibold)
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
              RoundedRectangle(cornerRadius: 16)
                .foregroundStyle(
                  nameIndex == i
                    ? Color.accentColor.opacity(0.18) : Color.gray.opacity(0.1))
            )
          }
        }
      }

      Spacer()

      Text("3  FACE THAT WAY AND MARK")
        .font(.caption)
        .fontWeight(.semibold)
        .foregroundStyle(Color.secondary)

      if !isFlat {
        tiltWarning
      }

      Button(action: { mark() }) {
        Text("Mark this direction")
          .font(.headline)
          .foregroundStyle(Color.white)
          .frame(maxWidth: .infinity, minHeight: 56)
          .background(
            RoundedRectangle(cornerRadius: 16)
              .foregroundStyle(Color.accentColor))
      }
    }
    .padding()
  }

  // MARK: while walking - the arrow first

  var walkingView: some View {
    VStack(spacing: 10) {
      Text("Follow the arrow back to " + markName)
        .font(.title3)
        .fontWeight(.semibold)
        .multilineTextAlignment(.center)

      Spacer()

      Image(systemName: "location.north.fill")
        .resizable()
        .scaledToFit()
        .frame(width: 140, height: 140)
        .foregroundStyle(Color.accentColor)
        .rotationEffect(Angle(radians: turnAngle))
        .padding(24)

      Text(turnText)
        .font(.title)
        .fontWeight(.semibold)

      if !isFlat {
        tiltWarning
      }

      Spacer()

      // The photo is the thing to line up with, so it sits right above the
      // save button. .buttonStyle(.plain) keeps the photo its own colors -
      // same as the PhotosPicker in 07-Instafilter.
      if let pickedImage {
        Button(action: { showingPhoto = true }) {
          HStack(spacing: 12) {
            Image(uiImage: pickedImage)
              .resizable()
              .scaledToFill()
              .frame(width: 64, height: 64)
              .clipShape(RoundedRectangle(cornerRadius: 12))
            VStack(alignment: .leading, spacing: 2) {
              Text("Back at the spot?")
                .font(.headline)
              Text("Tap to line up with your photo")
                .font(.caption)
                .foregroundStyle(Color.secondary)
            }
            Spacer()
            Image(systemName: "arrow.up.left.and.arrow.down.right")
              .foregroundStyle(Color.secondary)
          }
          .padding(10)
          .background(
            RoundedRectangle(cornerRadius: 16)
              .foregroundStyle(Color.gray.opacity(0.1)))
        }
        .buttonStyle(.plain)
      } else {
        Text("Back where you started? Face the way you marked, then save.")
          .font(.callout)
          .foregroundStyle(Color.secondary)
          .multilineTextAlignment(.center)
      }

      Button(action: { saveDrift() }) {
        Text("I'm back - save walk")
          .font(.headline)
          .foregroundStyle(Color.white)
          .frame(maxWidth: .infinity, minHeight: 56)
          .background(
            RoundedRectangle(cornerRadius: 16)
              .foregroundStyle(Color.accentColor))
      }

      // Kept small and away from the main button - it throws the walk away.
      // contentShape makes the whole 44 point strip tappable, not just the
      // letters.
      Button(action: { cancelMark() }) {
        Text("Start over")
          .foregroundStyle(Color.secondary)
          .frame(maxWidth: .infinity, minHeight: 44)
          .contentShape(Rectangle())
      }
      .padding(.top, 6)
    }
    .padding()
  }

  // MARK: pieces used by both

  // Shown only while the phone is tilted. Tap it to open the Level.
  var tiltWarning: some View {
    Button(action: { showingLevel = true }) {
      HStack(spacing: 8) {
        Image(systemName: "exclamationmark.triangle.fill")
        Text("Hold the phone flat")
          .fontWeight(.semibold)
        Spacer()
        Text("Level")
        Image(systemName: "chevron.right")
      }
      .font(.subheadline)
      .foregroundStyle(Color.orange)
      .padding(.horizontal, 12)
      .frame(maxWidth: .infinity, minHeight: 44)
      .background(
        RoundedRectangle(cornerRadius: 16)
          .foregroundStyle(Color.orange.opacity(0.15)))
    }
  }

  // The marked photo filling the screen, to hold up and match the view.
  var photoFullScreen: some View {
    ZStack {
      Color.black
        .ignoresSafeArea()
      if let pickedImage {
        Image(uiImage: pickedImage)
          .resizable()
          .scaledToFit()
      }
      VStack {
        Text("Turn until the view matches this photo")
          .font(.headline)
          .foregroundStyle(Color.white)
          .padding(.top)
        Spacer()
        Button(action: { showingPhoto = false }) {
          Text("Done")
            .font(.headline)
            .foregroundStyle(Color.white)
            .frame(maxWidth: .infinity, minHeight: 56)
            .background(
              RoundedRectangle(cornerRadius: 16)
                .foregroundStyle(Color.accentColor))
        }
        .padding()
      }
    }
  }

  // MARK: actions

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
