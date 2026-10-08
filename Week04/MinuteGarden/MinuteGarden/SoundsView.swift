//
// SoundsView.swift
// Page 2. Listen to the three sounds on their own.
// This is 04-Audio-State-Demo/PlayAudioView.swift with the names changed.
//

import SwiftUI
import AVFoundation

struct SoundsView: View {
    @State var soundIndex = 0
    @State var soundFile = bundleAudio[0]
    @State var player: AVAudioPlayer? = nil

    var body: some View {
        VStack {
            Text("Sounds")
                .font(.largeTitle)
                .padding()

            Text("Sound \(soundIndex) / 3")
            Text("Sound File Name: \(soundFile)")
                .padding()

            Spacer()

            HStack {
                Button("Play") {
                    player = loadBundleAudio(soundFile)
                    // Loop indefinitely
                    player?.numberOfLoops = -1
                    player?.play()
                }
                Spacer()
                Button("Stop") {
                    player?.stop()
                }
                Spacer()
                Button("Next") {
                    soundIndex = (soundIndex + 1) % bundleAudio.count
                    soundFile = bundleAudio[soundIndex]
                }
            }
            .font(.title2)
            .padding(40)
        }
    }
}

#Preview {
    SoundsView()
}
