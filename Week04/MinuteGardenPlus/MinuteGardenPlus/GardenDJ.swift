//
// GardenDJ.swift
// Audio functions collected into one @Observable class, so every page
// talks to the same player instead of each page making its own.
//
// Pattern copied from 04-Audio-State-Demo/AudioDJ.swift

import AVFoundation

// One ambience track. Small data-shaped struct, like Tile in Week03.
// plants are the emoji this track grows in the garden.
struct Track {
    let name: String
    let file: String
    let plants: [String]
}

// Global so every page can read it, same as `slides` in 04-SlideShowDemo/ContentView.swift
let tracks = [
    Track(name: "Morning Birds", file: "bbc-birds-1.m4a", plants: ["🌳", "🌿", "🍃", "🌲"]),
    Track(name: "Garden Birds", file: "bbc-birds-2.m4a", plants: ["🌷", "🌱", "🍀", "🌾"]),
    Track(name: "Slow Guitar", file: "Guitar.mp3", plants: ["🌻", "🌼", "🌺", "🏵️"]),
    Track(name: "Warm Synth", file: "Synth.mp3", plants: ["🪴", "🌵", "🌴", "🎍"]),
]

// Rings when a session finishes. Not an ambience track, so it is kept separate.
let bellFile = "scale-1.m4a"

@Observable
class GardenDJ {
    var trackIndex = 0
    var player: AVAudioPlayer? = nil
    // Second player so the bell can ring without stopping the ambience.
    var bell: AVAudioPlayer? = nil

    // class must have initializer
    init() {
        print("GardenDJ init")
    }

    func play() {
        player = loadBundleAudio(tracks[trackIndex].file)
        print("GardenDJ player", player as Any)
        // Loop indefinitely - a session is longer than any of the clips
        player?.numberOfLoops = -1
        player?.play()
    }

    func stop() {
        player?.stop()
        player = nil
    }

    // Keep playing the new track if we were already playing the old one.
    func choose(_ index: Int) {
        let wasPlaying = player != nil
        stop()
        trackIndex = index % tracks.count
        if wasPlaying {
            play()
        }
    }

    func next() {
        choose(trackIndex + 1)
    }

    func ringBell() {
        bell = loadBundleAudio(bellFile)
        bell?.play()
    }

    // Build an AVAudioPlayer from a file stored in the app bundle.
    // https://developer.apple.com/documentation/avfaudio/avaudioplayer
    func loadBundleAudio(_ fileName: String) -> AVAudioPlayer? {
        // The samples force unwrap this path. Using `if let` instead so a
        // misspelled file name prints a message rather than crashing the app.
        if let path = Bundle.main.path(forResource: fileName, ofType: nil) {
            let url = URL(fileURLWithPath: path)
            do {
                return try AVAudioPlayer(contentsOf: url)
            } catch {
                print("loadBundleAudio error", error)
            }
        } else {
            print("loadBundleAudio not in bundle", fileName)
        }
        return nil
    }
}
