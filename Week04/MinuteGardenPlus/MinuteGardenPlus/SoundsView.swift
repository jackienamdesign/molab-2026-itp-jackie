//
// SoundsView.swift
// Second page. Pick which ambience track the garden grows to, and preview it.
// The track picked here is the one the Grow page uses, because both pages
// read the same GardenDJ out of the environment.
//
// TimelineView + ProgressView + currentTime readout from
// 04-Audio-State-Demo/PlayAudioDJView.swift

import SwiftUI

struct SoundsView: View {
    @Environment(GardenDJ.self) var garden

    var body: some View {
        // TimelineView(.animation) redraws continuously, which is what makes
        // currentTime and the progress bar move while the track plays
        TimelineView(.animation) { context in
            VStack {
                Text("Sounds")
                    .font(.largeTitle)
                    .padding(.top)

                // One row per track. Tapping a row chooses it.
                ForEach(0..<tracks.count, id: \.self) { i in
                    Button(action: {
                        garden.choose(i)
                    }) {
                        HStack {
                            Image(systemName: garden.trackIndex == i ? "checkmark.circle.fill" : "circle")
                            Text(tracks[i].name)
                            Spacer()
                            // The plants this track grows
                            Text(tracks[i].plants.joined())
                        }
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 4)
                    .foregroundStyle(garden.trackIndex == i ? Color.green : Color.primary)
                }

                Spacer()

                if let player = garden.player {
                    ProgressView(value: player.currentTime, total: player.duration)
                        .padding(.horizontal)
                    Text("currentTime " + String(format: "%.1f", player.currentTime))
                        .font(.caption)
                    Text("duration " + String(format: "%.1f", player.duration))
                        .font(.caption)
                } else {
                    Text("not playing")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                HStack {
                    Button("Play") {
                        garden.play()
                    }
                    Spacer()
                    Button("Stop") {
                        garden.stop()
                    }
                    Spacer()
                    Button("Next") {
                        garden.next()
                    }
                }
                .padding(.horizontal, 40)
                .padding(.vertical)

                Button("Ring Bell") {
                    garden.ringBell()
                }
                .padding(.bottom)
            }
        }
    }
}

// GardenDJ must be established here or the preview crashes
#Preview {
    SoundsView()
        .environment(GardenDJ())
}
