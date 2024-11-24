//
//  Itinerary.swift
//  attemp1
//
//  Created by Nur Nisrina on 01/11/24.
//

import Foundation

struct Itinerary: Codable {
    var days: [Day]
}

struct Day: Identifiable, Codable {
    var id: UUID = UUID()
    var title: String
    var date: String
    var city: String
    var morning: Activity
    var afternoon: Activity
    var night: Activity

    private enum CodingKeys: String, CodingKey {
        case title, date, city, morning, afternoon, night
    }
}

struct Activity: Codable {
    var placeName: String
    var placeLatitude: String
    var placeLongitude: String
    var activity: String
}
