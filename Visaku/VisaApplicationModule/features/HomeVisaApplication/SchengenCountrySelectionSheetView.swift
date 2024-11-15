//
//  SchengenCountrySelectionSheetView.swift
//  VisaApplicationModule
//
//  Created by Nur Nisrina on 04/11/24.
//

import SwiftUI
import RepositoryModule

struct SchengenCountrySelectionSheetView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var viewModel: VisaHistoryViewModel
    @State var isAddNewSchengenCountry: Bool = false
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    ForEach(Countries.schengenCountryList.filter { viewModel.countrySearchKeyword.isEmpty || $0.contains(viewModel.countrySearchKeyword) }, id: \.self) { schengenCountry in
                        Button(action: {
                            if (viewModel.countries.count >= 1) {
                                isAddNewSchengenCountry = false
                                dismiss()
                            }
                            else {
                                isAddNewSchengenCountry = true
                            }
                            viewModel.countries.append(CountryData(name: schengenCountry))
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
            .sheet(isPresented: $isAddNewSchengenCountry) {
                SchengenVisaSelectionSheetView(
                    onDismiss: {
                        isAddNewSchengenCountry = false
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
