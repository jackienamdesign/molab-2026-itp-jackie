//
// Audio.swift
// The sound file names and the one function that loads them.
// Copied from 04-Audio-State-Demo/PlayAudioView.swift
//

import AVFoundation

// The three sounds you can play. Just an array of file names.
let bundleAudio = [
    "bbc-birds-1.m4a",
    "bbc-birds-2.m4a",
    "Guitar.mp3",
]

// Plays once when the timer reaches zero.
let chimeFile = "scale-1.m4a"

// The emoji the garden is grown from.
let plants = ["🌱", "🌿", "🌸", "🌼", "🍀"]

// Create an Audio Player given a file stored in the app bundle
// https://developer.apple.com/documentation/avfaudio/avaudioplayer
func loadBundleAudio(_ fileName: String) -> AVAudioPlayer? {
    let path = Bundle.main.path(forResource: fileName, ofType: nil)!
    let url = URL(fileURLWithPath: path)
    do {
        return try AVAudioPlayer(contentsOf: url)
    } catch {
        print("loadBundleAudio error", error)
    }
    return nil
}
