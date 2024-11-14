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
    
    public var hasData: Bool = true
    
    @Published var fetchVisaHistoryCompleted: fetchDataState = .idle
    @Published var fetchVisaHistoryUncompleted: fetchDataState = .idle
    
    @Published var tripCompleteList: [TripData]?
    @Published var tripuncompleteList: [TripData]?
    
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
    private func fetchVisaHistory(isCompleted: Bool) async throws -> [TripData]? {
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
                tripCompleteList = try await fetchVisaHistory(isCompleted: true)
                fetchVisaHistoryCompleted = .success
            } catch {
                fetchVisaHistoryCompleted = .error
            }
        }
    }
    
    func fetchVisaHistoryInProgressData() {
        fetchVisaHistoryUncompleted = .loading
        Task {
            do {
                tripuncompleteList = try await fetchVisaHistory(isCompleted: false)
                fetchVisaHistoryUncompleted = .success
            } catch {
                fetchVisaHistoryUncompleted = .error
            }
        }
    }
}
