//
//  SpecificCountryRequirement.swift
//  Visaku
//
//  Created by hendra on 12/11/24.
//

public enum VisaType: String, CaseIterable {
    case turis
    case pelajar
    case bisnis
    
    var displayName: String {
        switch self {
        case .turis: return "Tourism"
        case .pelajar: return "Student"
        case .bisnis: return "Business"
        }
    }
}

public struct CountrySpecificRequirement {
    let name: String
    let description: String
}

struct VisaRequirement {
    let type: VisaGeneralTouristDocumentType
    let displayName: String
    let description: String
    let requiresUpload: Bool
    let isOptionalUpload: Bool
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

        // Add country-specific requirements if available
        if visaType == .turis, let specificRequirements = countrySpecificRequirements[country] {
            for customRequirement in specificRequirements {
                // Check if this specific requirement is already included based on its type
                if !requirements.contains(where: { $0.displayName == customRequirement.displayName }) {
                    // Add the custom requirement
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
            type: .buktiKeuangan, // Same as general but more specific in description
            displayName: "Surat Keterangan Keuangan",
            description: "Selain rekening koran, diperlukan surat referensi dari bank sebagai bukti tambahan mengenai stabilitas keuangan untuk mendukung pengajuan visa.",
            requiresUpload: true,
            isOptionalUpload: false
        )
    ],
]
