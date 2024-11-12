//
//  SchengenCountrySelectionSheetView.swift
//  VisaApplicationModule
//
//  Created by Nur Nisrina on 04/11/24.
//

import SwiftUI

struct SchengenCountrySelectionSheetView: View {
    @Binding var countryKeyword: String
    @Binding var visaType: String
    @State var isAddNewSchengenCountry: Bool = false
    @State var countrySearchKeyword: String = ""
    var isUseSheet: Bool

    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    ForEach(Countries.schengenCountryList.filter { countrySearchKeyword.isEmpty || $0.contains(countrySearchKeyword) }, id: \.self) { schengenCountry in
                        Button(action: {
                            isAddNewSchengenCountry = true
                            countryKeyword = schengenCountry
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
            .searchable(text: $countrySearchKeyword, prompt: "Cari negara")
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("Pilih negara")
            .presentationDetents([.large])
            .sheet(isPresented: $isAddNewSchengenCountry) {
                SchengenVisaSelectionSheetView(
                    visaType: $visaType, countryKeyword: $countryKeyword,
                    onDismiss: {
                        isAddNewSchengenCountry = false
                    }
                )
            }
        }
    }
}

#Preview {
    @Previewable @State var countryKeyword: String = "Italia"
    @Previewable @State var visaType: String = "turis"
    @Previewable @State var isAddNewSchengenCountry: Bool = true
    @Previewable @State var isUseSheet: Bool = true
    
    SchengenCountrySelectionSheetView(countryKeyword: $countryKeyword, visaType: $visaType, isAddNewSchengenCountry: isAddNewSchengenCountry, isUseSheet: isUseSheet)
}
