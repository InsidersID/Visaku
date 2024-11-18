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
    
    @Published var navigationToCountryVisaApplication: Bool = false
    
    var hasData: Bool {
        (tripCompleteList?.isEmpty ?? true) == false || (tripUncompleteList?.isEmpty ?? true) == false
    }
    
    @Published var isShowChooseCountrySheet: Bool = false
    @Published var countries: [CountryData] = []
    var countryVisa: String {
        guard let longestCountry = countries.max(by: { ($0.endDate?.timeIntervalSince($0.startDate ?? Date()) ?? 0) <
            ($1.endDate?.timeIntervalSince($1.startDate ?? Date()) ?? 0) })
        else {
            return ""
        }
        return longestCountry.name
    }
    @Published var countryKeyword: String = ""
    @Published var isSchengenCountryChosen: Bool = false
    @Published var visaType: String = ""
    @Published var visaTypeIsEmpty: Bool = false
    var areAllCountriesFilledAndVisaTypeIsEmpty: Bool {
        let areAllCountriesValid = countries.allSatisfy { country in
            !(country.name.isEmpty || country.startDate == nil || country.endDate == nil)
        }
        return areAllCountriesValid && visaTypeIsEmpty
    }
    @Published var showContinueSheet: Bool = false

    @Published var isShowCountryApplicationView = false
    
    //SchengenCountrySelectionSheetView
    @Published var countrySearchKeyword : String = ""
    @Published var isAddNewSchengenCountry: Bool = false
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
                    print(data?.last)
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
