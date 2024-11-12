//
//  CountrySelectionSheetView.swift
//  VisaApplicationModule
//
//  Created by Nur Nisrina on 04/11/24.
//

import SwiftUI
import Foundation

struct CountrySelectionSheetView: View {
    @Binding var isSchengenCountryChosen: Bool
    @Binding var countryKeyword: String
    @Binding var visaType: String
    var onDismiss: () -> Void

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading) {
                    ForEach(Countries.countryList.filter { countryKeyword.isEmpty || $0.contains(countryKeyword) }, id: \.self) { country in
                        Button(action: {
                            if country == "Schengen Area" {
                                isSchengenCountryChosen = true
                            }
                        }) {
                            Text(country)
                                .font(.title3)
                                .foregroundStyle(.black)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding()
                                .bold()
                        }
                    }
                }
                .searchable(text: $countryKeyword, prompt: "Search")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        Text("Pilih negara")
                            .font(.headline)
                    }
                    ToolbarItem(placement: .topBarTrailing) {
                        Button(action: {
                            onDismiss()
                        }) {
                            Image(systemName: "xmark")
                                .font(.system(size: 16))
                                .padding(10)
                                .background(Circle().fill(Color.white))
                                .foregroundColor(.black)
                                .overlay(Circle().stroke(Color.gray, lineWidth: 1))
                        }
                    }
                }
                .presentationDetents([.medium])
            }
            .padding(.horizontal)
        }
        .sheet(isPresented: $isSchengenCountryChosen) {
            SchengenCountrySelectionSheetView(countryKeyword: $countryKeyword, visaType: $visaType, isUseSheet: false)
                .presentationDragIndicator(.visible)
        }
    }
}




