//
// ContentView.swift
// Three pages in a TabView, same as Week03's TenPrintTiles.
// TabView pattern from 03-About-Me.

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            GrowView()
                .tabItem {
                    Label("Grow", systemImage: "timer")
                }
            SoundsView()
                .tabItem {
                    Label("Sounds", systemImage: "speaker.wave.2")
                }
            AboutView()
                .tabItem {
                    Label("About", systemImage: "info.circle")
                }
        }
    }
}

// GardenDJ must be established here or the preview crashes,
// note from 04-SlideShowDemo/ContentView.swift
#Preview {
    ContentView()
        .environment(GardenDJ())
}
