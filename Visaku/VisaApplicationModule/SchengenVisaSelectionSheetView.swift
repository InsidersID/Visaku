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
    @State private var isSchengenCountryChosen: Bool = false

    let countryList: [String]
    let schengenCountryList: [String]
    @Binding var countryKeyword: String
    var onDismiss: () -> Void

    let countryFlags: [String: String] = [
        "Austria": "🇦🇹", "Belgia": "🇧🇪",
        "Denmark": "🇩🇰", "Finland": "🇫🇮",
        "Jerman": "🇩🇪", "Hungaria": "🇭🇺",
        "Iceland": "🇮🇸", "Italia": "🇮🇹",
        "Luxembourg": "🇱🇺", "Netherlands": "🇳🇱",
        "Norway": "🇳🇴", "Poland": "🇵🇱",
        "Portugal": "🇵🇹", "Spain": "🇪🇸",
        "Sweden": "🇸🇪", "Switzerland": "🇨🇭",
        "Perancis": "🇫🇷", "Republik Ceko": "🇨🇿",
        "Yunani": "🇬🇷"
    ]

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
                    AddNewSchengenCountryCard(isAddNewSchengenCountry: $isAddNewSchengenCountry, countryList: countryList, schengenCountryList: schengenCountryList, isSchengenCountryChosen: isSchengenCountryChosen, countryKeyword: $countryKeyword)
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
                .presentationDetents([.medium])
            }
        }
        
    }
}

#Preview {
    @Previewable @State var countryKeyword: String = "Iceland"
    let countryList = [
        "Arab Saudi", "Australia", "Bangladesh", "Bhutan",
        "China", "Jepang", "Korea Selatan", "Pakistan",
        "Schengen Area", "Taiwan"
    ]
    let schengenCountryList = [
        "Austria", "Belgia", "Bulgaria", "Denmark", "Finlandia",
        "Jerman", "Hungaria", "Iceland", "Italia",
        "Luksemburg", "Belanda", "Norwegia", "Polandia",
        "Portugal", "Spanyol", "Swedia", "Swiss",
        "Perancis", "Republik Ceko", "Yunani"
    ]
    
    SchengenVisaSelectionSheetView(
        countryList: countryList,
        schengenCountryList: schengenCountryList,
        countryKeyword: $countryKeyword,
        onDismiss: {
            
        }
    )
}
