//
// TimerView.swift
// Page 1. Counts down from 60 seconds while a sound loops.
// A plant is added every 10 seconds. A chime plays at zero.
//
// Countdown pattern from 04-Audio-State-Demo/CountDownTimerView.swift
// Play and stop pattern from 04-Audio-State-Demo/PlayAudioView.swift
//

import SwiftUI
import AVFoundation

struct TimerView: View {
    // Seconds left. The source of truth.
    @State var timeRemaining = 60

    // Flag for timer state.
    @State var isRunning = false

    // The garden so far, one string of emoji that keeps growing.
    @State var garden = ""

    // The sound that loops while the timer runs.
    @State var player: AVAudioPlayer? = nil

    // Timer gets called every second.
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
        VStack {
            Text("Minute Garden")
                .font(.largeTitle)
                .padding()

            Text("\(timeRemaining)")
                .font(.system(size: 100))

            Text(garden)
                .font(.system(size: 40))
                .padding()

            Spacer()

            HStack {
                Button("Start") {
                    isRunning = true
                    player = loadBundleAudio(bundleAudio[0])
                    // Loop indefinitely
                    player?.numberOfLoops = -1
                    player?.play()
                }
                Spacer()
                Button("Stop") {
                    isRunning = false
                    player?.stop()
                }
                Spacer()
                Button("Reset") {
                    isRunning = false
                    player?.stop()
                    timeRemaining = 60
                    garden = ""
                }
            }
            .font(.title2)
            .padding(40)
        }
        .onReceive(timer) { _ in
            // Block gets called every second.
            if isRunning && timeRemaining > 0 {
                timeRemaining -= 1
                print("timeRemaining", timeRemaining)

                // Every 10th second, add one random plant to the garden.
                if timeRemaining % 10 == 0 {
                    garden = garden + plants.randomElement()!
                }

                // Out of time. Stop the loop and play the chime once.
                if timeRemaining == 0 {
                    isRunning = false
                    player?.stop()
                    player = loadBundleAudio(chimeFile)
                    player?.play()
                }
            }
        }
    }
}

#Preview {
    TimerView()
}
