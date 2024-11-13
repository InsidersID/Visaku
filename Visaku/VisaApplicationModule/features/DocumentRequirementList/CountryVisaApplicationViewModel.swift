import SwiftUI
import RepositoryModule
import Foundation

enum TripState {
    case idle
    case loading
    case error
    case success
}

@MainActor
public class CountryVisaApplicationViewModel: ObservableObject {
    private var tripUseCase: TripUseCaseProtocol = TripUseCase.make()
    
    @Published var trip: TripEntity?
    
    var completionPercentage: Double {
        guard let requirements = trip?.visaRequirements else { return 0 }
        
        let requiredDocuments = requirements.filter { $0.type != .sponsor }
        let markedCount = requiredDocuments.filter { $0.isMarked }.count
        
        return requiredDocuments.isEmpty ? 0 : (Double(markedCount) / Double(requiredDocuments.count)) * 100
    }
    
    // Form data properties
    @Published var hasOtherResidence: String? = ""
    @Published var residenceType: String = ""
    @Published var residenceNumber: String = ""
    @Published var residenceExpiryDate: Date? = nil
    
    @Published var mainTravelPurpose: String? = ""
    @Published var additionalTravelPurpose: String? = ""
    
    @Published var visaEntryCount: String? = ""
    @Published var stayDuration: String = ""
    
    @Published var hasPreviousVisa: String? = ""
    @Published var previousVisaDetails: String? = ""
    @Published var previousVisaIssueDate: Date? = nil
    @Published var previousVisaExpiryDate: Date? = nil
    
    @Published var providedFingerprint: String? = ""
    @Published var fingerprintDate: Date? = nil
    @Published var fingerprintVisaDetails: String = ""
    @Published var lastSchengenEntryPlace: String = ""
    
    @Published var lastSchengenEntryCountry: String? = ""
    @Published var lastSchengenEntryDate: Date? = nil
    @Published var lastSchengenExitDate: Date? = nil
    @Published var arrivalDate: Date? = nil
    @Published var departureDate: Date? = nil
    
    @Published var travelPayer: String? = ""
    @Published var livingCostForm: String? = ""
    
    @Published var euFamilyLastName: String = ""
    @Published var euFamilyFirstName: String = ""
    @Published var euFamilyBirthDate: Date? = nil
    @Published var euFamilyNationality: String = ""
    @Published var euFamilyDocumentNumber: String = ""
    @Published var euFamilyRelation: String? = ""
    
    public func saveTripData(visaType: String, countrySelected: String) {
        guard trip == nil else { return }
        var newTrip = TripEntity(id: UUID().uuidString, visaType: visaType, country: countrySelected)
        if let visaTypeEnum = VisaType(rawValue: visaType) {
            let requirementsForCountry = VisaGeneralTouristDocumentType.getRequirements(for: visaTypeEnum, in: countrySelected)
            newTrip.visaRequirements = requirementsForCountry
        }
        Task {
            let isSuccess = try await tripUseCase.save(param: newTrip)
            if isSuccess {
                DispatchQueue.main.async {
                    self.trip = newTrip
                }
            }
        }
    }
}

//    enum ApplicationDocuments: Int, Identifiable {
//        case identity
//        case applicationForm
//        case flightTicket
//        case hotelReservation
//        case insurance
//        case bankReference
//
//        var id: Int { self.rawValue }
//    }
//}
