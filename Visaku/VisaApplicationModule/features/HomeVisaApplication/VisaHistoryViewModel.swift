//
//  VisaHistoryViewModel.swift
//  VisaApplicationModule
//
//  Created by Nur Nisrina on 30/10/24.
//

import Foundation
import RepositoryModule


public class VisaHistoryViewModel: ObservableObject {
    @MainActor
    private var tripUseCase: TripUseCaseProtocol = TripUseCase.make()

    @Published var fetchVisaHistoryCompleted: fetchDataState = .idle
    @Published var fetchVisaHistoryUncompleted: fetchDataState = .idle
    
    @Published var tripCompleteList: [TripEntity]?
    @Published var tripUncompleteList: [TripEntity]?
    
    var hasData: Bool {
        // Check if either list is not nil and has elements
        (tripCompleteList?.isEmpty ?? true) == false || (tripUncompleteList?.isEmpty ?? true) == false
    }
    
    @Published var isShowChooseCountrySheet: Bool = false
    @Published var countryKeyword: String = ""
    @Published var isSchengenCountryChosen: Bool = false
    @Published var visaType: String = ""
    @Published var visaTypeIsEmpty: Bool = false
    @Published var isShowCountryApplicationView = false
    @Published var showCalendar: Bool = false
    @Published var startDate: Date?
    @Published var endDate: Date?
    
    //SchengenCountrySelectionSheetView
    @Published var countrySearchKeyword : String = ""
    @Published var isAddNewSchengenCountry: Bool = false
    
    //
    @Published var isShowVisaTypeSheet: Bool = false
    
    public init() {
        
    }
    
    func navigateToCountryApplicationView() {
        //rest of it false
        isSchengenCountryChosen = false
        isShowChooseCountrySheet = false
        isShowVisaTypeSheet = false
        isAddNewSchengenCountry = false
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
            self.isShowCountryApplicationView = true
        })
    }
    
    @MainActor
    private func fetchVisaHistory(isCompleted: Bool) async throws -> [TripEntity]? {
        do {
            return try await tripUseCase.fetch(isCompleted: isCompleted)
        } catch {
            throw error
        }
    }
    
    func fetchVisaHistoryCompletedData() {
        fetchVisaHistoryCompleted = .loading
        Task {
            do {
                let data = try await fetchVisaHistory(isCompleted: true)
                
                DispatchQueue.main.async {
                    self.tripCompleteList = data
                    self.fetchVisaHistoryCompleted = .success
                }
            } catch {
                DispatchQueue.main.async {
                    self.fetchVisaHistoryCompleted = .error
                }
            }
        }
    }
    
    func fetchVisaHistoryInProgressData() {
        fetchVisaHistoryUncompleted = .loading
        Task {
            do {
                let data = try await fetchVisaHistory(isCompleted: false)
                DispatchQueue.main.async {
                    self.tripUncompleteList = data
                    self.fetchVisaHistoryUncompleted = .success
                }
            } catch {
                DispatchQueue.main.async {
                    self.fetchVisaHistoryUncompleted = .error
                }
            }
        }
    }
}
