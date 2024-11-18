//
//  PDFPreviewConfirmationViewModel.swift
//  Visaku
//
//  Created by Lonard Steven on 18/11/24.
//

import Foundation
import SwiftUI
import RepositoryModule

public class PDFPreviewConfirmationViewModel: ObservableObject {
    static let shared = PDFPreviewConfirmationViewModel()
    
    @Published var trip: TripEntity?
    
    @MainActor
    private var tripUseCase: TripUseCaseProtocol = TripUseCase.make()

    @Published var fetchAccountData: fetchDataState = .idle
    
    @MainActor
    func fetchAccountDataFromTrip(_ tripId: String) {
        fetchAccountData = .loading
        Task {
            do {
                if let data = try await tripUseCase.fetchById(id: tripId) {
                    self.trip = data
                    self.fetchAccountData = .success
                } else {
                    self.fetchAccountData = .error
                }
            } catch {
                DispatchQueue.main.async {
                    self.fetchAccountData = .error
                }
            }
        }
    }
}
