import SwiftUI
import RepositoryModule

@MainActor
public class CountryVisaApplicationViewModel: ObservableObject {
    @Published var applicationDocuments: ApplicationDocuments?
    
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
