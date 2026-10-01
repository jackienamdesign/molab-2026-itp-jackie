//
// GrowView.swift
// The timer page. Pick a session length, press Start, and a plant appears
// every 10 seconds while the ambience track loops. The bell rings at zero.
//
// Countdown + Timer.publish pattern from 04-Audio-State-Demo/CountDownTimerView.swift
// Timer driving a change every tick from 04-SlideShowDemo/SlidesAudioView.swift

import SwiftUI

// Session lengths in seconds, shown as buttons
let sessionChoices = [60, 180, 300]

// One plant per this many seconds
let secondsPerPlant = 10

// Plants per row in the garden
let plantsPerRow = 6

struct GrowView: View {
    @State var sessionLength = sessionChoices[0]
    @State var timeRemaining = sessionChoices[0]
    @State var isRunning = false
    // The garden so far. Emoji strings, grown one at a time.
    @State var plants: [String] = []

    // Timer gets called every second
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    @Environment(GardenDJ.self) var garden

    var body: some View {
        VStack {
            Text("Minute Garden")
                .font(.largeTitle)
                .padding(.top)

            Text(timeText(timeRemaining))
                .font(.system(size: 72))

            Text(tracks[garden.trackIndex].name)
                .font(.title3)
                .foregroundStyle(.secondary)

            // Length buttons. Changing length resets the session.
            HStack {
                ForEach(0..<sessionChoices.count, id: \.self) { i in
                    Button(timeText(sessionChoices[i])) {
                        sessionLength = sessionChoices[i]
                        resetAction()
                    }
                    .padding(.horizontal, 8)
                    .foregroundStyle(sessionLength == sessionChoices[i] ? Color.green : Color.gray)
                }
            }
            .padding(.vertical, 8)

            GardenView(plants: plants)
                .padding()

            Spacer()

            HStack {
                Button(action: startStopAction) {
                    Image(systemName: isRunning ? "pause.circle.fill" : "play.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 60, height: 60)
                }
                Spacer()
                Button(action: resetAction) {
                    Image(systemName: "arrow.counterclockwise.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 60, height: 60)
                        .foregroundStyle(.gray)
                }
            }
            .padding(.horizontal, 60)
            .padding(.bottom)
        }
        .onReceive(timer) { _ in
            // Block gets called every second, whether or not we are running
            if isRunning && timeRemaining > 0 {
                timeRemaining -= 1
                print("timeRemaining", timeRemaining)

                // Seconds counted so far this session
                let elapsed = sessionLength - timeRemaining
                // Grow a plant on every 10th second
                if elapsed % secondsPerPlant == 0 {
                    plants.append(tracks[garden.trackIndex].plants.randomElement()!)
                }

                if timeRemaining == 0 {
                    finishAction()
                }
            }
        }
        .onDisappear {
            // Leaving the page pauses the session so audio does not keep looping
            if isRunning {
                startStopAction()
            }
        }
    }

    // Seconds as m:ss, String(format:) like the samples use for durations
    func timeText(_ seconds: Int) -> String {
        return String(format: "%d:%02d", seconds / 60, seconds % 60)
    }

    func startStopAction() {
        isRunning.toggle()
        if isRunning {
            garden.play()
        } else {
            garden.stop()
        }
    }

    func resetAction() {
        isRunning = false
        garden.stop()
        timeRemaining = sessionLength
        plants = []
    }

    func finishAction() {
        isRunning = false
        garden.stop()
        garden.ringBell()
    }
}

// The grown plants, laid out in rows of 6.
// Nested ForEach rows instead of a grid, same as the tile rows in Week03.
struct GardenView: View {
    var plants: [String]

    var body: some View {
        VStack {
            if plants.count == 0 {
                Text("Press play to grow a garden")
                    .foregroundStyle(.secondary)
            }
            // Number of rows needed to hold every plant
            let rowCount = (plants.count + plantsPerRow - 1) / plantsPerRow
            ForEach(0..<rowCount, id: \.self) { row in
                HStack {
                    ForEach(0..<plantsPerRow, id: \.self) { col in
                        // Index into plants for this row and column
                        let i = row * plantsPerRow + col
                        if i < plants.count {
                            Text(plants[i])
                                .font(.system(size: 34))
                                .frame(width: 44)
                        } else {
                            // Empty slot. It needs the same .frame as a real plant,
                            // otherwise the last row centers instead of lining up
                            // under the row above it.
                            Text(" ")
                                .font(.system(size: 34))
                                .frame(width: 44)
                        }
                    }
                }
            }
        }
    }
}

// GardenDJ must be established here or the preview crashes
#Preview {
    GrowView()
        .environment(GardenDJ())
}
