//
//  SchengenCountrySelectionSheetView.swift
//  VisaApplicationModule
//
//  Created by Nur Nisrina on 04/11/24.
//

import SwiftUI

struct SchengenCountrySelectionSheetView: View {
    let countryList: [String]
    let schengenCountryList: [String]
    @Binding var countryKeyword: String
    @State var isAddNewSchengenCountry: Bool = false
    var isUseSheet: Bool

    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    ForEach(schengenCountryList.filter { countryKeyword.isEmpty || $0.contains(countryKeyword) }, id: \.self) { schengenCountry in
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
            .searchable(text: $countryKeyword, prompt: "Cari negara")
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("Pilih negara")
            .presentationDetents([.large])
            .sheet(isPresented: $isAddNewSchengenCountry) {
                if isUseSheet {
                    SchengenVisaSelectionSheetView(
                        countryList: countryList,
                        schengenCountryList: schengenCountryList,
                        countryKeyword: $countryKeyword,
                        onDismiss: {
                            isAddNewSchengenCountry = false
                        }
                    )
                }
            }
        }
    }
}
