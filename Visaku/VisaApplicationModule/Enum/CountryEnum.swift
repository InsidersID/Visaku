//
//  CountryEnum.swift
//  VisaApplicationModule
//
//  Created by hendra on 17/10/24.
//

import Foundation

public enum ItineraryGeneralTouristDocumentType: String {
    case hotelAccommodation, flightTicket, itinerary, relativeInvitationLetter
    
    static var data: [ItineraryGeneralTouristDocumentType] {
        return [.hotelAccommodation, .flightTicket, .itinerary, .relativeInvitationLetter]
    }
}

public enum FinancialGeneralTouristDocumentType: String {
    case bankStatement, sponsorFinancialStatement, sponsorshipLetter, workStatementLetter, salarySlip, companyRegistrationProof, studentRegistrationProof, selfFundedStatement, selfFundedSuitabilityProof
    
    static var data: [FinancialGeneralTouristDocumentType] {
        return [.bankStatement, .sponsorFinancialStatement, .sponsorshipLetter, .workStatementLetter, .salarySlip, .companyRegistrationProof, .studentRegistrationProof, .selfFundedStatement, .selfFundedSuitabilityProof]
    }
}

public enum PrimaryGeneralTouristDocumentType: String {
    case applicationForm
    
    static var data: [PrimaryGeneralTouristDocumentType] {
        return [.applicationForm]
    }
}

public enum ItalyTouristDocument: String {
    case bankReferenceLetter
    
    static var data: [ItalyTouristDocument] {
        return [.bankReferenceLetter]
    }
}


struct VisaDocumentRequirements: Equatable {
    let primaryDocuments: [PrimaryGeneralTouristDocumentType]
    let itineraryDocuments: [ItineraryGeneralTouristDocumentType]
    let financialDocuments: [FinancialGeneralTouristDocumentType]
    let countrySpecificDocuments: [String]
}

//struct CountryData {
//    let name: String
//    let png: String
//    let visaTypes: [VisaType]
//    let flagEmoji: String
//}

//public enum Country: String, Codable, CaseIterable {
//    case italy
//    case germany
//    
//    var data: CountryData {
//        let flagImage = rawValue.replacingOccurrences(of: " ", with: "-") + "-flag.png"
//        let visaTypes: [VisaType]
//        let flagEmoji: String
//        
//        // Define Visa and required documents for Italy
//        switch self {
//        case .italy:
//            let tourismVisaDocuments = VisaDocumentRequirements(
//                primaryDocuments: PrimaryGeneralTouristDocumentType.data,
//                itineraryDocuments: ItineraryGeneralTouristDocumentType.data,
//                financialDocuments: FinancialGeneralTouristDocumentType.data,
//                countrySpecificDocuments: ItalyTouristDocument.data.map { $0.rawValue }
//            )
//            visaTypes = [
//                VisaType(
//                    name: "Tourism",
//                    value: "turis",
//                    documentRequirements: tourismVisaDocuments
//                ),
//                VisaType(
//                    name: "Business",
//                    value: "bisnis",
//                    documentRequirements: VisaDocumentRequirements(
//                        primaryDocuments: [],
//                        itineraryDocuments: [],
//                        financialDocuments: [],
//                        countrySpecificDocuments: []
//                    )
//                )
//            ]
//            flagEmoji = "🇮🇹"
//        case .germany:
//            let businessVisaDocuments = VisaDocumentRequirements(
//                primaryDocuments: PrimaryGeneralTouristDocumentType.data,
//                itineraryDocuments: ItineraryGeneralTouristDocumentType.data,
//                financialDocuments: FinancialGeneralTouristDocumentType.data,
//                countrySpecificDocuments: []
//            )
//            let tourismVisaDocuments = VisaDocumentRequirements(
//                primaryDocuments: PrimaryGeneralTouristDocumentType.data,
//                itineraryDocuments: ItineraryGeneralTouristDocumentType.data,
//                financialDocuments: FinancialGeneralTouristDocumentType.data,
//                countrySpecificDocuments: []
//            )
//            visaTypes = [
//                VisaType(
//                    name: "Business",
//                    value: "bisnis",
//                    documentRequirements: businessVisaDocuments
//                ),
//                VisaType(
//                    name: "Tourism",
//                    value: "turis",
//                    documentRequirements: tourismVisaDocuments
//                )
//            ]
//            flagEmoji = "🇩🇪"
//        }
//        
//        return CountryData(name: rawValue.capitalized, png: flagImage, visaTypes: visaTypes, flagEmoji: flagEmoji)
//    }
//    
//    static var data: [CountryData] {
//        return Country.allCases.map { $0.data }
//    }
//}

public enum Countries {
    
    static let countryList: [String] = [
        "Arab Saudi", "Australia", "Bangladesh", "Bhutan",
        "China", "Jepang", "Korea Selatan", "Pakistan",
        "Schengen Area", "Taiwan"
    ]
    
    static let schengenCountryList: [String] = [
        "Austria", "Belgia", "Bulgaria", "Denmark", "Finlandia",
        "Jerman", "Hungaria", "Islandia", "Italia",
        "Luxemburg", "Belanda", "Norwegia", "Polandia",
        "Portugal", "Spanyol", "Swedia", "Swiss",
        "Prancis", "Republik Ceko", "Yunani"
    ]

    static let schengenCountryFlags: [String: String] = [
        "Austria": "🇦🇹", "Belgia": "🇧🇪",
        "Bulgaria": "🇧🇬", "Denmark": "🇩🇰", "Finlandia": "🇫🇮",
        "Jerman": "🇩🇪", "Hungaria": "🇭🇺",
        "Islandia": "🇮🇸", "Italia": "🇮🇹",
        "Luxemburg": "🇱🇺", "Belanda": "🇳🇱",
        "Norwegia": "🇳🇴", "Polandia": "🇵🇱",
        "Portugal": "🇵🇹", "Spanyol": "🇪🇸",
        "Swedia": "🇸🇪", "Swiss": "🇨🇭",
        "Prancis": "🇫🇷", "Republik Ceko": "🇨🇿", "Yunani": "🇬🇷"
    ]
    
    static func isSchengenCountry(_ country: String) -> Bool {
        return schengenCountryList.contains(country)
    }
}
