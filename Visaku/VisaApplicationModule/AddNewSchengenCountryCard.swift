//
//  AddNewSchengenCountryCard.swift
//  VisaApplicationModule
//
//  Created by Nur Nisrina on 07/11/24.
//

import SwiftUI
import UIComponentModule

struct AddNewSchengenCountryCard: View {
    @Binding var isAddNewSchengenCountry: Bool
    let countryList: [String]
    let schengenCountryList: [String]
    @State var isSchengenCountryChosen: Bool = false
    @Binding var countryKeyword: String
    
    var body: some View {
        CardContainer(cornerRadius: 18) {
            Button(action: {
                isAddNewSchengenCountry = true
                countryKeyword = ""
            }, label: {
                HStack {
                    Text("Tambah negara")
                        .foregroundStyle(.secondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.vertical, 12)
                    Image(systemName: "plus")
                        .background(Circle().fill(Color.white))
                        .padding(3)
                        .foregroundStyle(.secondary)
                        .overlay(Circle().stroke(Color.gray, lineWidth: 1))
                }
            })
        }
        .foregroundStyle(.secondary)
        .sheet(isPresented: $isAddNewSchengenCountry) {
            SchengenCountrySelectionSheetView(countryList: countryList, schengenCountryList: countryList, countryKeyword: $countryKeyword, isAddNewSchengenCountry: false, isUseSheet: false)
                .presentationDetents([.large])
                .presentationDragIndicator(.visible)
        }
    }
}

#Preview {
    @Previewable @State var isAddNewSchengenCountry = false
    @Previewable @State var isSchengenCountryChosen = false
    @Previewable @State var countryKeyword = ""

    AddNewSchengenCountryCard(isAddNewSchengenCountry: $isAddNewSchengenCountry, countryList: ["italy", "jerman"], schengenCountryList: ["italy", "jerman"], isSchengenCountryChosen: isSchengenCountryChosen, countryKeyword: $countryKeyword)
}
