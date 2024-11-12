//
//  SchengenCountrySelectionSheetView.swift
//  VisaApplicationModule
//
//  Created by Nur Nisrina on 04/11/24.
//

import SwiftUI

struct SchengenCountrySelectionSheetView: View {
    @EnvironmentObject var viewModel: VisaHistoryViewModel
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    ForEach(Countries.schengenCountryList.filter { viewModel.countrySearchKeyword.isEmpty || $0.contains(viewModel.countrySearchKeyword) }, id: \.self) { schengenCountry in
                        Button(action: {
                            viewModel.isAddNewSchengenCountry = true
                            viewModel.countryKeyword = schengenCountry
                        }) {
                            Text(schengenCountry)
                                .font(.title3)
                                .foregroundStyle(.black)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding()
                                .bold()
                        }
                    }
                }
                .padding(.horizontal)
            }
            .searchable(text: $viewModel.countrySearchKeyword, prompt: "Cari negara")
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("Pilih negara")
            .presentationDetents([.large])
            .sheet(isPresented: $viewModel.isAddNewSchengenCountry) {
                SchengenVisaSelectionSheetView(
                    onDismiss: {
                        viewModel.isAddNewSchengenCountry = false
                    }
                )
                .environmentObject(viewModel)
            }
        }
    }
}

#Preview {

    SchengenCountrySelectionSheetView()
        .environmentObject(VisaHistoryViewModel())
}
