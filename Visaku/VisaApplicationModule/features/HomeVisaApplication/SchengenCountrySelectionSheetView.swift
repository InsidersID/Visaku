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
                    ForEach(viewModel.filteredSchengenCountries.filter { viewModel.countrySearchKeyword.isEmpty || $0.contains(viewModel.countrySearchKeyword) }, id: \.self) { schengenCountry in
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
                                .font(.custom("Inter-SemiBold", size: 17))
                                .foregroundStyle(Color.blackOpacity5)
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
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Pilih negara")
                        .font(.custom("Inter-SemiBold", size: 16))
                        .foregroundStyle(Color.blackOpacity5)
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        dismiss()
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
