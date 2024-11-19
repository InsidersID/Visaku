//
//  Enum.swift
//  Visaku
//
//  Created by hendra on 14/11/24.
//

import RepositoryModule
import Foundation

enum fetchDataState {
    case idle
    case loading
    case error
    case success
}

public struct TripDataUIModel: Identifiable {
    public let id: String
    public let isCompleted: Bool
    public let visaType: String
    public let country: String
    public let countries: [String]
    public let percentage: Double
    public let date: Date
    
    // Initialize with TripData
    public init(from trip: TripEntity) {
        self.id = trip.id
        self.isCompleted = trip.isCompleted
        self.visaType = trip.visaType
        self.country = trip.country.capitalized
        self.countries = trip.countries.map { $0.name }
        self.percentage = TripDataUIModel.calculatePercentage(for: trip.visaRequirements)
        self.date = trip.createdAt
    }
    
    // Calculate the percentage of completed visa requirements, excluding `sponsor`
    private static func calculatePercentage(for requirements: [VisaRequirement]?) -> Double {
        guard let requirements = requirements else { return 0 }
        
        let relevantRequirements = requirements.filter { $0.type != .sponsor }
        let completedRequirements = relevantRequirements.filter { $0.isMarked }
        
        return (Double(completedRequirements.count) / Double(relevantRequirements.count)) * 100
    }
}
