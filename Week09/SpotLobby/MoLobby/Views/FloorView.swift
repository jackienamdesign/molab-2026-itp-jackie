//
//  FloorView.swift
//  Week09: how many people are in each area right now. The counts come from
//  the sample's snapshot listener, so they change live on every phone.
//

import SwiftUI

struct FloorView: View {

    @Environment(LobbyModel.self) var lobbyModel

    var body: some View {
        NavigationStack {
            List {
                ForEach(0..<zoneNames.count, id: \.self) { index in
                    zoneRowView(index: index)
                }
            }
            .navigationTitle("The floor right now")
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    private func zoneRowView(index: Int) -> some View {
        let people = lobbyModel.peopleInZones[index]
        return VStack(alignment: .leading) {
            Text(zoneNames[index])
                .font(.headline)
            Text(zoneHints[index])
                .font(.subheadline)
            Text("\(people) of \(zoneSeats[index]) seats taken")
            Text(timeMessage(people: people, seats: zoneSeats[index]))
                .font(.subheadline)
            if lobbyModel.myZone == zoneNames[index] {
                Button("I left") {
                    lobbyModel.saveZone("")
                }
            } else {
                Button("I'm here") {
                    lobbyModel.saveZone(zoneNames[index])
                }
            }
        }
    }
}
