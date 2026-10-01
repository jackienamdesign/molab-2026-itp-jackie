//
// MinuteGardenPlusApp.swift
// MinuteGarden
//
// Created by Jackie Nam for Week04.
//
// GardenDJ is created once here and handed to every page with .environment(),
// so the Grow page and the Sounds page share one audio player.
// Pattern from 04-Audio-State-Demo/Audio_State_DemoApp.swift

import SwiftUI

@main
struct MinuteGardenPlusApp: App {
    @State var garden = GardenDJ()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(garden)
        }
    }
}
