//
//  Helper.swift
//  Visaku
//
//  Created by Lonard Steven on 08/11/24.
//

import SwiftUI

class Helper {
    static func getStatusBarHeight() -> CGFloat {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            return windowScene.statusBarManager?.statusBarFrame.height ?? 0
        } else {
            return 0
        }
    }
    
    static func parseIdentityData(_ input: String) -> (placeOfBirth: String, dateOfBirth: String)? {
        // Step 1: Split by comma
        let components = input.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) }
        
        // Check if there are exactly two parts: place of birth and date of birth
        guard components.count == 2 else {
            return nil
        }
        
        let placeOfBirth = components[0].capitalized
        
        // Step 2: Convert date format from "11-07-2000" to "11 July 2000"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy" // input format
        
        if let date = dateFormatter.date(from: components[1]) {
            // Change to desired output format
            dateFormatter.dateFormat = "dd MMMM yyyy"
            let formattedDate = dateFormatter.string(from: date)
            return (placeOfBirth, formattedDate)
        }
        
        return nil
    }
}

