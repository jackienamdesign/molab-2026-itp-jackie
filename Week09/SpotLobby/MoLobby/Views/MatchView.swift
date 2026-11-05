//
//  MatchView.swift
//  Week09: the quick questionnaire. Form and Toggle are from AppSettingView,
//  the Toggles there are commented out but show the shape.
//

import SwiftUI

struct MatchView: View {

    @Environment(LobbyModel.self) var lobbyModel

    @State private var collaborate = false
    @State private var shop = false
    @State private var group = false
    @State private var solo = false

    var body: some View {
        // Recomputed on every toggle and every snapshot, so the match stays live
        let order = rankZones(collaborate: collaborate, shop: shop, group: group, solo: solo)
        let match = pickZone(order: order, people: lobbyModel.peopleInZones)
        let people = lobbyModel.peopleInZones[match]

        NavigationStack {
            Form {
                Section {
                    Text("What do you need today?")
                        .font(.headline)
                    Toggle("In the mood to collaborate", isOn: $collaborate)
                    Toggle("Need to go to the shop", isOn: $shop)
                    Toggle("Group project to work on", isOn: $group)
                    Toggle("Want solo work time", isOn: $solo)
                }
                Section {
                    Text("Go to \(zoneNames[match])")
                        .font(.title2)
                    Text(zoneHints[match])
                        .font(.subheadline)
                    Text("\(people) of \(zoneSeats[match]) seats taken")
                    Text(timeMessage(people: people, seats: zoneSeats[match]))
                    if match != order[0] {
                        Text("\(zoneNames[order[0]]) is your first pick, but it's full")
                            .font(.subheadline)
                    }
                    if lobbyModel.myZone != zoneNames[match] {
                        Button("I'm sitting here") {
                            lobbyModel.saveZone(zoneNames[match])
                        }
                    }
                }
            }
            .navigationTitle("Find a seat")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
