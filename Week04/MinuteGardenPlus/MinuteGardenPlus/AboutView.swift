//
// AboutView.swift
// Third page. What the app is, and where the parts came from.

import SwiftUI

struct AboutView: View {
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "leaf.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 70, height: 70)
                .foregroundStyle(.green)
                .padding(.top, 40)

            Text("Minute Garden")
                .font(.largeTitle)

            Text("A quiet timer. Pick a sound, press play, and a plant grows every 10 seconds until the bell rings.")
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            Spacer()

            VStack(alignment: .leading, spacing: 6) {
                Text("Built in Week04")
                    .font(.headline)
                Text("AVAudioPlayer for the sounds")
                Text("Timer.publish for the countdown")
                Text("@Observable GardenDJ shared with .environment")
                Text("TimelineView to animate the progress bar")
            }
            .font(.callout)

            Spacer()

            VStack(spacing: 4) {
                Text("Jackie Nam, ITP Mobile Lab 2026")
                Text("Audio clips from the class sample")
                Text("04-Audio-State-Demo")
                Text("Birds: BBC Rewind. Scale: youraccompanist.com")
            }
            .font(.caption)
            .foregroundStyle(.secondary)
            .multilineTextAlignment(.center)
            .padding(.bottom, 30)
        }
    }
}

#Preview {
    AboutView()
}
