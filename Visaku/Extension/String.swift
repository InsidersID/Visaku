//
//  String.swift
//  Visaku
//
//  Created by hendra on 24/11/24.
//

import Foundation

extension String {
    /// Extracts the numeric part of the string before encountering non-numeric characters.
    func numericPart() -> Double? {
        // Use a regular expression to find the numeric part at the beginning of the string
        let pattern = "^[0-9]*\\.?[0-9]*"
        if let range = self.range(of: pattern, options: .regularExpression) {
            return Double(self[range])
        }
        return nil
    }
}
