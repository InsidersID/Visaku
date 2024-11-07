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

struct VisaType: Identifiable, Equatable {
    let id: UUID = UUID()
    let name: String
    let value: String
    let documentRequirements: VisaDocumentRequirements
}

struct VisaDocumentRequirements: Equatable {
    let primaryDocuments: [PrimaryGeneralTouristDocumentType]
    let itineraryDocuments: [ItineraryGeneralTouristDocumentType]
    let financialDocuments: [FinancialGeneralTouristDocumentType]
    let countrySpecificDocuments: [String]  // Flexible for any country-specific docs
}

struct CountryData {
    let name: String
    let png: String
    let visaTypes: [VisaType]
}

public enum Country: String, Codable, CaseIterable {
    case italy
    case germany
    
    var data: CountryData {
        let flagImage = rawValue.replacingOccurrences(of: " ", with: "-") + "-flag.png"
        let visaTypes: [VisaType]
        
        // Define Visa and required documents for Italy
        switch self {
        case .italy:
            let tourismVisaDocuments = VisaDocumentRequirements(
                primaryDocuments: PrimaryGeneralTouristDocumentType.data,
                itineraryDocuments: ItineraryGeneralTouristDocumentType.data,
                financialDocuments: FinancialGeneralTouristDocumentType.data,
                countrySpecificDocuments: ItalyTouristDocument.data.map { $0.rawValue }
            )
            visaTypes = [
                VisaType(
                    name: "Tourism",
                    value: "turis",
                    documentRequirements: tourismVisaDocuments
                ),
                VisaType(
                    name: "Business",
                    value: "bisnis",
                    documentRequirements: VisaDocumentRequirements(
                        primaryDocuments: [],
                        itineraryDocuments: [],
                        financialDocuments: [],
                        countrySpecificDocuments: []
                    )
                )
            ]
        case .germany:
            let businessVisaDocuments = VisaDocumentRequirements(
                primaryDocuments: PrimaryGeneralTouristDocumentType.data,
                itineraryDocuments: ItineraryGeneralTouristDocumentType.data,
                financialDocuments: FinancialGeneralTouristDocumentType.data,
                countrySpecificDocuments: []
            )
            let tourismVisaDocuments = VisaDocumentRequirements(
                primaryDocuments: PrimaryGeneralTouristDocumentType.data,
                itineraryDocuments: ItineraryGeneralTouristDocumentType.data,
                financialDocuments: FinancialGeneralTouristDocumentType.data,
                countrySpecificDocuments: []
            )
            visaTypes = [
                VisaType(
                    name: "Business",
                    value: "bisnis",
                    documentRequirements: businessVisaDocuments
                ),
                VisaType(
                    name: "Tourism",
                    value: "turis",
                    documentRequirements: tourismVisaDocuments
                )
            ]
        }
        
        return CountryData(name: rawValue.capitalized, png: flagImage, visaTypes: visaTypes)
    }
    
    static var data: [CountryData] {
        return Country.allCases.map { $0.data }
    }
}

