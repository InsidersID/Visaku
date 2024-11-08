//
//  SchengenVisaSelectionSheetView.swift
//  VisaApplicationModule
//
//  Created by Nur Nisrina on 04/11/24.
//

import SwiftUI
import UIComponentModule

struct SchengenVisaSelectionSheetView: View {
    @State private var visaType: String = ""
    @State var isAddNewSchengenCountry: Bool = false
    @State var isShowVisaTypeSheet: Bool = false
    @State var isShowChosenVisaSheet: Bool = false
    @State private var isSchengenCountryChosen: Bool = false

    @Binding var countryKeyword: String
    var onDismiss: () -> Void

    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    HStack {
                        Image(systemName: "map")
                            .font(.system(size: 100))
                        VStack(spacing: 8) {
                            Text("Kenapa visa Schengen harus ditentukan?")
                                .font(.system(size: 21))
                                .bold()
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .lineLimit(nil)
                                .fixedSize(horizontal: false, vertical: true)
                            Text("Kamu bisa masuk menggunakan satu visa yang sama untuk beberapa negara Uni Eropa.")
                                .font(.system(size: 15))
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .lineLimit(nil)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                    }
                    .padding()
                    Divider()
                    VStack {
                        Text("Daftar negara terpilih")
                            .font(.title2)
                            .bold()
                            .frame(maxWidth: .infinity, alignment: .leading)
                        ForEach(1..<2) { countryItem in
                            CountrySelectionCard(countryKeyword: countryKeyword, visaType: $visaType, isShowVisaTypeSheet: $isShowVisaTypeSheet)
                        }
                    }
                    .padding()
                    AddNewSchengenCountryCard(isAddNewSchengenCountry: $isAddNewSchengenCountry, isSchengenCountryChosen: isSchengenCountryChosen, countryKeyword: $countryKeyword)
                    .padding(.horizontal)
                }
                
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        Text("Penentuan visa Schengen")
                            .font(.system(size: 18))
                            .bold()
                    }
                    ToolbarItem(placement: .topBarTrailing) {
                        Button(action: {
                            onDismiss()
                        }) {
                            Image(systemName: "xmark")
                                .font(.system(size: 14))
                                .padding(10)
                                .bold()
                                .background(Circle().fill(Color.white))
                                .foregroundColor(.black)
                                .overlay(Circle().stroke(Color.gray, lineWidth: 1))
                        }
                    
                    }
                }
                .sheet(isPresented: .constant(!visaType.isEmpty)) {
                    VStack {
                        VStack(spacing: 18) {
                            VStack(spacing: 5) {
                                Text("Visa yang kamu akan ajukan adalah")
                                    .font(.system(size: 14))
                                    .foregroundStyle(.secondary)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                Text("Visa\(visaType) \(countryKeyword) \(Countries.schengenCountryFlags[countryKeyword] ?? "")")
                                    .font(.system(size: 20))
                                    .bold()
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            CustomButton(text: "Selanjutnya", color: Color(.primary5)) {
                            }
                        }
                        .padding()
                    }
                    .presentationDetents([.height(150)])
                }

            }
        }
        
    }
}

#Preview {
    @Previewable @State var countryKeyword: String = "Italia"
    let countryList = [
        "Arab Saudi", "Australia", "Bangladesh", "Bhutan",
        "China", "Jepang", "Korea Selatan", "Pakistan",
        "Schengen Area", "Taiwan"
    ]
    SchengenVisaSelectionSheetView(
        countryKeyword: $countryKeyword,
        onDismiss: {
            
        }
    )
}
