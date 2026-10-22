//
//  LogView.swift
//  TurnBack - Week07 homework, Jackie Nam
//
//  "My Walks" - every walk I have saved, newest first. Reversed the same way
//  ContentView in 06-ImageEditDemoJSON shows its items.
//
//  Drift is how far the arrow was off when I got back to the spot and faced the
//  way I marked. If the gyroscope were perfect it would always read 0.
//
//  Week06 UX pass: the answer comes first - the average drift sits at the top,
//  above the list it is worked out from. Numbers are written the way a person
//  would say them ("8° off", "22 min"), not "+008°". Clearing takes two taps,
//  because it deletes every walk and there is no undo.
//
//  Week07: walks with a photo show it in place of the emoji. Walks saved
//  before Week07 have no photo, so they keep their emoji.
//

import SwiftUI

struct LogView: View {
  @Environment(Document.self) var document

  // First tap on Clear sets this; only a second tap deletes.
  @State var confirmingClear = false

  // Average of how far off each walk was, ignoring left or right.
  // A plain loop, Week02 style.
  var averageDrift: Int {
    var total = 0.0
    for entry in document.model.entries {
      total = total + abs(entry.driftDegrees)
    }
    return Int(total / Double(document.model.entries.count))
  }

  // The saved photo for a walk, or nil if it has none.
  func photo(entry: DriftEntry) -> UIImage? {
    if let photoFile = entry.photoFile {
      return document.loadPhoto(fileName: photoFile)
    }
    return nil
  }

  var walkCountText: String {
    let count = document.model.entries.count
    if count == 1 {
      return "average drift over 1 walk"
    }
    return "average drift over " + String(count) + " walks"
  }

  var body: some View {
    VStack {
      if document.model.entries.isEmpty {
        Spacer()
        Image(systemName: "figure.walk")
          .font(.system(size: 48))
          .foregroundStyle(Color.secondary)
          .padding(.bottom)
        Text("No walks yet")
          .font(.title3)
          .fontWeight(.semibold)
        Text("Mark a direction on Way Back, walk a loop, then tap I'm back.")
          .font(.callout)
          .foregroundStyle(Color.secondary)
          .multilineTextAlignment(.center)
          .padding()
        Spacer()
      } else {
        VStack(spacing: 4) {
          Text(String(averageDrift) + "\u{00B0}")
            .font(.system(size: 56, weight: .bold, design: .rounded))
          Text(walkCountText)
            .font(.callout)
            .foregroundStyle(Color.secondary)
        }
        .padding(.vertical)

        List {
          ForEach(document.model.entries.reversed()) { entry in
            HStack(spacing: 14) {
              if let image = photo(entry: entry) {
                Image(uiImage: image)
                  .resizable()
                  .scaledToFill()
                  .frame(width: 56, height: 56)
                  .clipShape(RoundedRectangle(cornerRadius: 10))
              } else {
                Text(entry.emoji)
                  .font(.system(size: 34))
                  .frame(width: 56, height: 56)
              }

              VStack(alignment: .leading, spacing: 2) {
                Text(entry.name)
                  .font(.headline)
                Text(entry.date.formatted(date: .abbreviated, time: .shortened))
                  .font(.caption)
                  .foregroundStyle(Color.secondary)
              }

              Spacer()

              VStack(alignment: .trailing, spacing: 2) {
                Text(String(Int(abs(entry.driftDegrees))) + "\u{00B0} off")
                  .font(.headline)
                Text(String(Int(entry.minutes.rounded())) + " min")
                  .font(.caption)
                  .foregroundStyle(Color.secondary)
              }
            }
            .padding(.vertical, 6)
          }
        }
        .listStyle(.plain)

        Button(action: { clearTapped() }) {
          Text(confirmingClear ? "Tap again to delete every walk" : "Clear all walks")
            .fontWeight(confirmingClear ? .semibold : .regular)
            .foregroundStyle(Color.red)
            .frame(maxWidth: .infinity, minHeight: 44)
            .contentShape(Rectangle())
        }
        .padding(.horizontal)
        .padding(.bottom)
      }
    }
    .navigationTitle("My Walks")
    .onDisappear {
      confirmingClear = false
    }
  }

  func clearTapped() {
    if confirmingClear {
      document.clearAll()
      confirmingClear = false
    } else {
      confirmingClear = true
    }
  }
}

#Preview {
  NavigationStack {
    LogView()
  }
  .environment(Document())
}
