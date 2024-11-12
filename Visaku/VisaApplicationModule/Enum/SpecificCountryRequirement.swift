//
//  SpecificCountryRequirement.swift
//  Visaku
//
//  Created by hendra on 12/11/24.
//

import Foundation
import RepositoryModule

public enum VisaType: String, CaseIterable {
    case turis
    case pelajar
    case bisnis
    
    var displayName: String {
        switch self {
        case .turis: return "turis"
        case .pelajar: return "pelajar"
        case .bisnis: return "bisnis"
        }
    }
}

public struct CountrySpecificRequirement {
    let name: String
    let description: String
}

extension VisaGeneralTouristDocumentType {
    @MainActor
    static func getRequirements(for visaType: VisaType, in country: String) -> [VisaRequirement] {
        // Start with general requirements
        var requirements = VisaGeneralTouristDocumentType.data.map {
            VisaRequirement(
                type: $0,
                displayName: $0.displayName,
                description: $0.description,
                requiresUpload: $0.requiresUpload,
                isOptionalUpload: $0.isOptionalUpload
            )
        }

        if visaType == .turis, let specificRequirements = countrySpecificRequirements[country] {
            for customRequirement in specificRequirements {
                if !requirements.contains(where: { $0.displayName == customRequirement.displayName }) {
                    requirements.append(customRequirement)
                }
            }
        }
        
        return requirements
    }
}

let countrySpecificRequirements: [String: [VisaRequirement]] = [
    "Italia": [
        VisaRequirement(
            type: .buktiKeuangan,
            displayName: "Surat Keterangan Keuangan",
            description: "Selain rekening koran, diperlukan surat referensi dari bank sebagai bukti tambahan mengenai stabilitas keuangan untuk mendukung pengajuan visa.",
            requiresUpload: true,
            isOptionalUpload: false
        )
    ],
]
