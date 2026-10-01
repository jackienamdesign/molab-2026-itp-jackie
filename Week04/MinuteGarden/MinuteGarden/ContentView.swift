//
// ContentView.swift
// Three pages in a TabView, same as Week03's TenPrintTiles.
// TabView pattern from 03-About-Me.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            TimerView()
                .tabItem {
                    Label("Timer", systemImage: "timer")
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

#Preview {
    ContentView()
}
