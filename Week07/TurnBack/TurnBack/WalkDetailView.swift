//
//  WalkDetailView.swift
//  TurnBack - Week07 homework, Jackie Nam
//
//  Week07 UX pass: one walk, opened from My Walks. The photo full width, then
//  the two numbers that matter - how far off, and for how long - and which
//  way the arrow was off, which the list leaves out.
//
//  Delete takes two taps, the same pattern as Clear all walks. After deleting,
//  dismiss() goes back to the list. @Environment(\.dismiss) is new - it reads
//  a value from the environment the same way @Environment(Document.self) does,
//  but this value is "close this page".
//

import SwiftUI

struct WalkDetailView: View {
  @Environment(Document.self) var document
  @Environment(\.dismiss) var dismiss

  let entry: DriftEntry

  @State var confirmingDelete = false

  // Which way the arrow was off, in words. Positive drift means the arrow was
  // pointing to the right of the marked direction (see turnText in
  // HeadingView).
  var driftText: String {
    let degrees = Int(abs(entry.driftDegrees))
    if degrees < 3 {
      return "The arrow was spot on"
    }
    if entry.driftDegrees > 0 {
      return "The arrow pointed " + String(degrees) + "\u{00B0} to the right"
    }
    return "The arrow pointed " + String(degrees) + "\u{00B0} to the left"
  }

  // The full size photo, or nil for walks without one.
  var photo: UIImage? {
    if let photoFile = entry.photoFile {
      return document.loadPhoto(fileName: photoFile)
    }
    return nil
  }

  var body: some View {
    VStack(spacing: 14) {
      if let photo {
        Image(uiImage: photo)
          .resizable()
          .scaledToFit()
          .frame(maxHeight: 320)
          .clipShape(RoundedRectangle(cornerRadius: 16))
      } else {
        Text(entry.emoji)
          .font(.system(size: 80))
          .padding(.top)
      }

      VStack(spacing: 4) {
        Text("From " + entry.name)
          .font(.title2)
          .fontWeight(.semibold)
        Text(entry.date.formatted(date: .abbreviated, time: .shortened))
          .font(.callout)
          .foregroundStyle(Color.secondary)
      }

      HStack(spacing: 10) {
        VStack(spacing: 2) {
          Text(String(Int(abs(entry.driftDegrees))) + "\u{00B0}")
            .font(.title)
            .fontWeight(.bold)
          Text("off")
            .font(.caption)
            .foregroundStyle(Color.secondary)
        }
        .frame(maxWidth: .infinity, minHeight: 72)
        .background(
          RoundedRectangle(cornerRadius: 16)
            .foregroundStyle(Color.gray.opacity(0.1)))

        VStack(spacing: 2) {
          Text(String(Int(entry.minutes.rounded())))
            .font(.title)
            .fontWeight(.bold)
          Text("minutes")
            .font(.caption)
            .foregroundStyle(Color.secondary)
        }
        .frame(maxWidth: .infinity, minHeight: 72)
        .background(
          RoundedRectangle(cornerRadius: 16)
            .foregroundStyle(Color.gray.opacity(0.1)))
      }

      Text(driftText)
        .font(.callout)
        .foregroundStyle(Color.secondary)

      Spacer()

      Button(action: { deleteTapped() }) {
        Text(confirmingDelete ? "Tap again to delete this walk" : "Delete walk")
          .fontWeight(confirmingDelete ? .semibold : .regular)
          .foregroundStyle(Color.red)
          .frame(maxWidth: .infinity, minHeight: 44)
          .contentShape(Rectangle())
      }
    }
    .padding()
    .navigationTitle("Walk")
    .navigationBarTitleDisplayMode(.inline)
  }

  func deleteTapped() {
    if confirmingDelete {
      document.deleteEntry(entry: entry)
      dismiss()
    } else {
      confirmingDelete = true
    }
  }
}

#Preview {
  NavigationStack {
    WalkDetailView(entry: DriftEntry(emoji: "🚗", name: "the car", minutes: 22, driftDegrees: -8))
  }
  .environment(Document())
}
