//
//  VisaHistoryViewModel.swift
//  VisaApplicationModule
//
//  Created by Nur Nisrina on 30/10/24.
//

import Foundation


public class VisaHistoryViewModel: ObservableObject {
    public var hasData: Bool = false
    
    @Published var isShowChooseCountrySheet: Bool = false
    @Published var countryKeyword: String = ""
    @Published var isSchengenCountryChosen: Bool = false
    @Published var visaType: String = ""
    @Published var visaTypeIsEmpty: Bool = false
    @Published var isShowCountryApplicationView = false
    
    
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
    
    
}
