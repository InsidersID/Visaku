import SwiftUI
import RepositoryModule

@MainActor
public class CountryVisaApplicationViewModel: ObservableObject {
    @Published var applicationDocuments: ApplicationDocuments?
    @Published var isMarkedStatus: [VisaGeneralTouristDocumentType: Bool] = [:]
    
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
    
    init(isMarkedStatus: [VisaGeneralTouristDocumentType: Bool]) {
        self.isMarkedStatus = isMarkedStatus
    }
    
    public init() {}

    enum ApplicationDocuments: Int, Identifiable {
        case identity
        case applicationForm
        case flightTicket
        case hotelReservation
        case insurance
        case bankReference

        var id: Int { self.rawValue }
    }
}
