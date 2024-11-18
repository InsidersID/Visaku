//
//  CountrySelectionSheetView.swift
//  VisaApplicationModule
//
//  Created by Nur Nisrina on 04/11/24.
//

import SwiftUI
import Foundation

struct CountrySelectionSheetView: View {
    @EnvironmentObject var viewModel: VisaHistoryViewModel
    var onDismiss: () -> Void

    private var filteredCountries: [String] {
        if viewModel.countryKeyword.isEmpty {
            return Countries.countryList
        } else {
            return Countries.countryList.filter { $0.contains(viewModel.countryKeyword) }
        }
    }

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading) {
                    ForEach(filteredCountries, id: \.self) { country in
                        Button(action: {
                            if country == "Schengen Area" {
                                viewModel.isSchengenCountryChosen = true
                            }
                        }) {
                            Text(country)
                                .font(.custom("Inter-SemiBold", size: 17))
                                .foregroundStyle(Color.blackOpacity5)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding()
                                .bold()
                        }
                    }
                }
                .searchable(text: $viewModel.countryKeyword, prompt: "Cari")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        Text("Pilih negara")
                            .font(.custom("Inter-SemiBold", size: 16))
                            .foregroundStyle(Color.blackOpacity5)
                    }
                    ToolbarItem(placement: .topBarTrailing) {
                        Button(action: {
                            onDismiss()
                        }) {
                            Image(systemName: "xmark")
                                .imageScale(.medium)
                                .fontWeight(.semibold)
                                .foregroundColor(.blackOpacity5)
                                .frame(width: 40, height: 40)
                                .background(
                                    Circle()
                                        .stroke(Color.blackOpacity2, lineWidth: 1)
                                )
                        }
                    }
                }
                .presentationDetents([.medium])
            }
            .padding(.horizontal)
        }
        .sheet(isPresented: $viewModel.isSchengenCountryChosen) {
            SchengenCountrySelectionSheetView()
                .presentationDragIndicator(.visible)
                .environmentObject(viewModel)
        }
    }
}




