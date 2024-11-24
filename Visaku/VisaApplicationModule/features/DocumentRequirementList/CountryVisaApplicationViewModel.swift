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
    private var itineraryUseCase: ItineraryUseCaseProtocol = ItineraryUseCase.make()
    
    @Published var trip: TripEntity?
    
    init(trip: TripEntity? = nil) {
        self.trip = trip
    }
    
    var completionPercentage: Double {
        guard let requirements = trip?.visaRequirements else { return 0 }
        
        let requiredDocuments = requirements.filter { $0.type != .sponsor }
        let markedCount = requiredDocuments.filter { $0.isMarked }.count
        
        return requiredDocuments.isEmpty ? 0 : (Double(markedCount) / Double(requiredDocuments.count)) * 100
    }
    
    // Form data properties
    @Published var isIdentity: Bool = false
//    @Published var selectedIdentity: AccounselectedAccounttEntity?
    @Published var showDocumentDetail: Bool = false
    @Published var isNotificationVisible: Bool = false
    @Published var aiItineraryGenerator: Bool = false
    
    @Published var isApplicantUnder18: String? = ""
    @Published var custodianFirstName: String = ""
    @Published var custodianLastName: String = ""
    @Published var custodianAddress: String = ""
    @Published var custodianPhoneNumber: String = ""
    @Published var custodianEmail: String = ""
    @Published var custodianNationality: String = ""
    
    @Published var hasOtherResidence: String? = ""
    @Published var residenceType: String = ""
    @Published var residenceNumber: String = ""
    @Published var residenceExpiryDate: Date? = nil
    
    @Published var mainTravelPurpose: String? = ""
    @Published var additionalTravelPurpose: String? = ""
    @Published var mainCountriesDestination: String = ""
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
    
    @Published var invitationDetailsName: String = ""
    @Published var invitationDetailsEmail: String = ""
    @Published var invitationDetailsPhoneNumber: String = ""
    @Published var invitationDetailsAddress: String = ""
    @Published var invitationDetailsProvince: String = ""
    @Published var invitationDetailsLastName: String = ""
    @Published var invitationDetailsOfficePhoneNumber: String = ""
    
//    @Published var invitationType: String? = ""
    
//    @Published var hotelName: String = ""
//    @Published var hotelAddress: String = ""
//    @Published var hotelPostalCode: String = ""
//    @Published var hotelCity: String = ""
//    @Published var hotelProvince: String = ""
//    @Published var hotelPhoneNumber: String = ""
//    @Published var hotelFaxNumber: String = ""
//    @Published var hotelEmail: String = ""
//    
//    @Published var inviterFirstName: String = ""
//    @Published var inviterLastName: String = ""
//    @Published var inviterDOB: Date? = nil
//    @Published var inviterAddress: String = ""
//    @Published var inviterPostalCode: String = ""
//    @Published var inviterCity: String = ""
//    @Published var inviterProvince: String = ""
//    @Published var inviterPhoneNumber: String = ""
//    @Published var inviterFaxNumber: String = ""
//    @Published var inviterEmail: String = ""
//    
//    @Published var companyName: String = ""
//    @Published var companyAddress: String = ""
//    @Published var companyPostalCode: String = ""
//    @Published var companyCity: String = ""
//    @Published var companyProvince: String = ""
//    @Published var companyPhoneNumber: String = ""
//    @Published var companyFaxNumber: String = ""
//    @Published var companyEmail: String = ""
//    @Published var companyRepresentativeFirstName: String = ""
//    @Published var companyRepresentativeLastName: String = ""
//    @Published var companyRepresentativeAddress: String = ""
//    @Published var companyRepresentativePhoneNumber: String = ""
//    @Published var companyRepresentativeFaxNumber: String = ""
//    @Published var companyRepresentativeEmail: String = ""
    
    @Published var isSponsored: String? = ""
    @Published var travelPayer: String? = ""
    @Published var otherSponsor: String = ""

    @Published var livingCostForm: String? = ""
    @Published var otherLivingCostForm: String = ""

    @Published var euFamilyLastName: String = ""
    @Published var euFamilyFirstName: String = ""
    @Published var euFamilyBirthDate: Date? = nil
    @Published var euFamilyNationality: String = ""
    @Published var euFamilyDocumentNumber: String = ""
    @Published var euFamilyRelation: String? = ""
    
    @Published var isSelfApply: String? = ""
    @Published var bookerName: String = ""
    @Published var bookerEmailAndAddress: String = ""
    @Published var bookerPhoneNumber: String = ""
    
    // Application view navigation
    @Published var isPresentingConfirmationView: Bool = false
    @Published var isShowConfirmation: Bool = false
    @Published var isItinerary: Bool = false
    @Published var isFormApplication: Bool = false
    
    @Published var isShowPreviewVisaApplicationForm: Bool = false
    @Published var isShowJSONDownload: Bool = false
    
    @Published var isConfirmationErrorNotificationVisible: Bool = false
    
    func startNotificationTimer() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.isNotificationVisible = false
        }
    }
    
    func startConfirmationErrorNotificationTimer() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.isConfirmationErrorNotificationVisible = false
        }
    }
    
    public func saveTripData(visaType: String, countrySelected: String, countries: [CountryData]) {
        guard trip == nil else { return }
        if let visaTypeEnum = VisaType(rawValue: visaType) {
            Task {
                var newTrip = TripEntity(id: UUID().uuidString, visaType: visaType, country: countrySelected, contries: countries)
                
                let requirementsForCountry = VisaGeneralTouristDocumentType.getRequirements(for: visaTypeEnum, in: countrySelected)
                newTrip.visaRequirements = requirementsForCountry
                let isSuccess = try await tripUseCase.save(param: newTrip)
                if isSuccess {
                    DispatchQueue.main.async {
                        self.trip = newTrip
                        self.isNotificationVisible = true
                    }
                    try await tripUseCase.update(param: newTrip)
                } else {
                    print("Failed to save trip")
                    self.isConfirmationErrorNotificationVisible = true
                }
            }
        }
    }
    
    func uploadDocument(documentType: VisaRequirement, payload: UploadPayload) async {
        switch payload {
        case .url(let url):
            guard var trip = trip,
                  let index = trip.visaRequirements?.firstIndex(where: { $0.type == documentType.type }) else {
                return
            }
            trip.visaRequirements?[index].uploadPayload = .url(url)
            do {
                let isSuccess = try await tripUseCase.update(param: trip)
                if isSuccess {
                    self.trip = trip
                }
            } catch {
                print("Failed to update trip: \(error.localizedDescription)")
            }
        case .data(let data):
            guard var trip = trip,
                  let index = trip.visaRequirements?.firstIndex(where: { $0.type == documentType.type }) else {
                return
            }
            trip.visaRequirements?[index].uploadPayload = .data(data)
            do {
                let isSuccess = try await tripUseCase.update(param: trip)
                if isSuccess {
                    self.trip = trip
                }
            } catch {
                print("Failed to update trip: \(error.localizedDescription)")
            }
        }
    }
    
    func updateDocumentMark(for documentType: VisaRequirement, to isMarked: Bool) async {
        guard var trip = trip,
              let index = trip.visaRequirements?.firstIndex(where: { $0.type == documentType.type }) else {
            return
        }
        trip.visaRequirements?[index].isMarked = isMarked
        do {
            let isSuccess = try await tripUseCase.update(param: trip)
            if isSuccess {
                self.trip = trip
            }
        } catch {
            print("Failed to update trip: \(error.localizedDescription)")
        }
    }
    
    func updateSelectedAccount(account : AccountEntity) async {
        do {
            guard var trip = trip else {
                return
            }
            trip.account = account
            let isSuccess = try await tripUseCase.update(param: trip)
            if isSuccess {
                self.trip = trip
            }
        } catch {
            print("Failed to update trip: \(error.localizedDescription)")
        }
    }
    
    func deleteTrip() async {
        if let tripId = trip?.id {
            do {
                let isSuccess = try await tripUseCase.delete(id: tripId)
                if isSuccess {
                    self.trip = nil
                }
            } catch {
                self.isConfirmationErrorNotificationVisible = true
                print("Failed to delete trip: \(error.localizedDescription)")
            }
        }
    }
    
    func confirmationButtonTapped() {
        Task {
            do {
                guard var trip else { return }
                trip.isCompleted = true
                let isSuccess = try await tripUseCase.update(param: trip)
                if isSuccess {
                    self.trip = trip
                }
                DispatchQueue.main.async {
                    self.isPresentingConfirmationView = false
                }
            } catch {
                trip?.isCompleted = false
                print("Failed to confirmation trip: \(error.localizedDescription)")
                self.isConfirmationErrorNotificationVisible = true
            }
        }
    }
    
    func saveItinerary(file: URL?) {
        Task {
            do {
                let itinerary = ItineraryEntity(id: UUID().uuidString, file: file)
                print("file location: \(file?.path)")
                let isSuccess = try await itineraryUseCase.save(param: itinerary)
                
                if !isSuccess {
                    print("Failed to save itinerary")
                }
                if let trip = self.trip {
                    trip.itinerary = itinerary
                    let isSuccessToUpdateTrip = try await tripUseCase.update(param: trip)
                    
                    if !isSuccessToUpdateTrip {
                        print("Failed to update trip")
                    }
                }
            } catch {
                print("Error saving itinerary: \(error.localizedDescription)")
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
