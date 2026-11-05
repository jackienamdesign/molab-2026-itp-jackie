//
//  Zones.swift
//  Week09: the four areas of the ITP floor, in the order you walk them.
//  Parallel arrays, same as maskEmojis / maskHints in my Week08 EmojiMirror.
//

import Foundation

let zoneNames = ["Kitchen", "Shop", "ER", "Design Lab"]

let zoneHints = [
    "Near the kitchen and the shop. Noisy, lots of foot traffic",
    "3D printers, wood shop, soldering, soft lab. Often taken",
    "Open tables for working together. Quieter, short walk to the shop",
    "Quiet, wide open seating. Very far from the shop"
]

// Guesses until I count the seats on the floor
let zoneSeats = [12, 10, 16, 20]

// Week09: first match wins, so the order is the design, like pickEmoji in Week08.
// Each list is the zones to try, best first. 0 Kitchen, 1 Shop, 2 ER, 3 Design Lab
func rankZones(collaborate: Bool, shop: Bool, group: Bool, solo: Bool) -> [Int] {
    if shop && solo { return [1, 2, 0, 3] }
    if shop { return [1, 0, 2, 3] }
    if group || collaborate { return [2, 0, 3, 1] }
    if solo { return [3, 2, 1, 0] }
    return [2, 3, 0, 1]
}

// The first zone in the order with a free seat. If all are full, the best match
func pickZone(order: [Int], people: [Int]) -> Int {
    for index in order {
        if people[index] < zoneSeats[index] {
            return index
        }
    }
    return order[0]
}

func timeMessage(people: Int, seats: Int) -> String {
    if people >= seats { return "Full right now" }
    if people * 2 >= seats { return "Filling up, go soon" }
    return "Good time to go"
}
