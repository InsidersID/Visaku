//
//  Itinerary.swift
//  attemp1
//
//  Created by Nur Nisrina on 01/11/24.
//

struct Itinerary: Codable {
    var days: [Day]
}

struct Day: Codable {
    let day: String
    let date: String
    let activities: Activities
}

struct Activities: Codable {
    let morning: [String]
    let afternoon: [String]
    let evening: [String]
}
