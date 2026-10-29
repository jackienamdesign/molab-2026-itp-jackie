//
//  ContentView.swift
//  EmojiMirror - Week08 homework, Jackie Nam
//
//  From the class sample 07-FaceMeshUI: the AR camera view full screen, and
//  a dark panel at the bottom saying what your face is doing.
//
//  Week08: the panel now starts with a row of every emoji the mask can be.
//  The one on your face right now is full strength and the rest are faded,
//  like the selected effect button in 08-CameraRecorder's FilterSelectionView.
//  Under it, how to get the one you're showing, and a line of things to try.
//

import SwiftUI

struct ContentView: View {
  @State var tracker = FaceTracker()

  var body: some View {
    ZStack(alignment: .bottom) {
      if tracker.isSupported {
        FaceViewAR(tracker: tracker)
          .ignoresSafeArea()
      } else {
        Color.black.ignoresSafeArea()
      }

      VStack(alignment: .leading, spacing: 6) {
        // Week08: the emoji row
        HStack {
          ForEach(0..<maskEmojis.count, id: \.self) { i in
            Text(maskEmojis[i])
              .font(.largeTitle)
              .opacity(tracker.emoji == maskEmojis[i] ? 1 : 0.3)
              .frame(maxWidth: .infinity)
          }
        }

        // Week08: the hint for the emoji showing, e.g. "Wink"
        if let i = maskEmojis.firstIndex(of: tracker.emoji) {
          Text(maskHints[i])
            .font(.title2.bold())
        }

        Text(tracker.status)
          .font(.headline)
        if tracker.faceDetected {
          Text(String(format: "smile %.2f   blink L %.2f   blink R %.2f",
                      tracker.smile, tracker.blinkLeft, tracker.blinkRight))
            .font(.caption.monospacedDigit())
          // Week08: the two I added
          Text(String(format: "mouth open %.2f   tongue %.2f",
                      tracker.jawOpen, tracker.tongueOut))
            .font(.caption.monospacedDigit())
        } else {
          Text("Try: smile, wink, close your eyes, open your mouth, stick out your tongue")
            .font(.caption)
        }
      }
      .foregroundStyle(.white)
      .padding()
      .frame(maxWidth: .infinity, alignment: .leading)
      .background(.black.opacity(0.5), in: RoundedRectangle(cornerRadius: 12))
      .padding()
    }
  }
}

#Preview {
  ContentView()
}
