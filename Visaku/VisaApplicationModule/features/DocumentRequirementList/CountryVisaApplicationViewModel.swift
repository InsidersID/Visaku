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
    
//    @Published var isMarkedStatus: [VisaGeneralTouristDocumentType: Bool] = [:]
    @Published var trip: TripEntity?
    
    // Initialize with optional isMarkedStatus dictionary
//    init(isMarkedStatus: [VisaGeneralTouristDocumentType: Bool] = [:]) {
//        self.isMarkedStatus = isMarkedStatus
//    }
    
    var completionPercentage: Double {
        guard let requirements = trip?.visaRequirements else { return 0 }
        let markedCount = requirements.filter { $0.isMarked }.count
        return (Double(markedCount) / Double(requirements.count)) * 100
    }
    
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
