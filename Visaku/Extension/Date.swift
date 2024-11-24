//
//  Date.swift
//  Visaku
//
//  Created by hendra on 24/11/24.
//

import Foundation

extension Date {
    static func formatDateRange(startDate: Date?, endDate: Date?) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none

        if let start = startDate, let end = endDate {
            return "\(formatter.string(from: start)) - \(formatter.string(from: end))"
        } else {
            return "No date range"
        }
    }
}
