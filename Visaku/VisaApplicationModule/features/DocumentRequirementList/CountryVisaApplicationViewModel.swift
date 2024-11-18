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
    @Published var isIdentity: Bool = false
    @Published var selectedIdentity: AccountEntity?
    
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
    
    @Published var invitationType: String? = ""
    
    @Published var hotelName: String = ""
    @Published var hotelAddress: String = ""
    @Published var hotelPostalCode: String = ""
    @Published var hotelCity: String = ""
    @Published var hotelProvince: String = ""
    @Published var hotelPhoneNumber: String = ""
    @Published var hotelFaxNumber: String = ""
    @Published var hotelEmail: String = ""
    
    @Published var inviterFirstName: String = ""
    @Published var inviterLastName: String = ""
    @Published var inviterDOB: Date? = nil
    @Published var inviterAddress: String = ""
    @Published var inviterPostalCode: String = ""
    @Published var inviterCity: String = ""
    @Published var inviterProvince: String = ""
    @Published var inviterPhoneNumber: String = ""
    @Published var inviterFaxNumber: String = ""
    @Published var inviterEmail: String = ""
    
    @Published var companyName: String = ""
    @Published var companyAddress: String = ""
    @Published var companyPostalCode: String = ""
    @Published var companyCity: String = ""
    @Published var companyProvince: String = ""
    @Published var companyPhoneNumber: String = ""
    @Published var companyFaxNumber: String = ""
    @Published var companyEmail: String = ""
    @Published var companyRepresentativeFirstName: String = ""
    @Published var companyRepresentativeLastName: String = ""
    @Published var companyRepresentativeAddress: String = ""
    @Published var companyRepresentativePhoneNumber: String = ""
    @Published var companyRepresentativeFaxNumber: String = ""
    @Published var companyRepresentativeEmail: String = ""
    
    @Published var travelPayer: String? = ""
    @Published var livingCostForm: String? = ""
    
    @Published var euFamilyLastName: String = ""
    @Published var euFamilyFirstName: String = ""
    @Published var euFamilyBirthDate: Date? = nil
    @Published var euFamilyNationality: String = ""
    @Published var euFamilyDocumentNumber: String = ""
    @Published var euFamilyRelation: String? = ""
    
    // Application view navigation
    @Published var showConfirmationButton: Bool = false
    @Published var isPresentingConfirmationView: Bool = false
    @Published var isShowPrintDownloadButton: Bool = false
    @Published var isShowConfirmation: Bool = false
    @Published var isItinerary: Bool = false
    @Published var isFormApplication: Bool = false
    
    @Published var isShowPreviewVisaApplicationForm: Bool = false
    @Published var isShowJSONDownload: Bool = false
    
    public func saveTripData(visaType: String, countrySelected: String, countries: [CountryData]) {
        guard trip == nil else { return }
        var newTrip = TripEntity(id: UUID().uuidString, visaType: visaType, country: countrySelected, contries: countries)
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
