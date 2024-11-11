import SwiftUI
import RepositoryModule

@MainActor
public class CountryVisaApplicationViewModel: ObservableObject {
    @Published var applicationDocuments: ApplicationDocuments?
    @Published var isMarkedStatus: [VisaGeneralTouristDocumentType: Bool] = [:]
    
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
