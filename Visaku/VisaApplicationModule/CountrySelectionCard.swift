//
//  CountrySelectionCard.swift
//  VisaApplicationModule
//
//  Created by Nur Nisrina on 06/11/24.
//

import SwiftUI
import UIComponentModule

struct CountrySelectionCard: View {
    
    let countryKeyword: String
    @Binding var visaType: String
    @Binding var isShowVisaTypeSheet: Bool
    
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
        CardContainer(cornerRadius: 18) {
            
            VStack {
                let flag = countryFlags[countryKeyword] ?? ""
                Text("\(countryKeyword) \(flag)")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.title)
                    .bold()
                VStack {
                    VisaTypeRow(visaType: $visaType, isShowVisaTypeSheet: $isShowVisaTypeSheet)
                    DateRow(label: "Berangkat", text: $visaType)
                    DateRow(label: "Pulang", text: $visaType)
                }
                .padding(.vertical, 5)
            }
        }
    }
}

struct VisaTypeRow: View {
    @Binding var visaType: String
    @Binding var isShowVisaTypeSheet: Bool

    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading) {
                    Text("Jenis visa")
                        .foregroundStyle(.secondary)
                        .font(.system(size: 14))
                    Text("\(visaType == "" ? "" : "Visa \(visaType)")")
                        .font(.system(size: 16))
                        .padding(.bottom, 10)
                        .padding(.top, 0.5)
                        .bold()
                }
                .onTapGesture {
                    isShowVisaTypeSheet = true
                }
                .sheet(isPresented: $isShowVisaTypeSheet) {
                    VisaTypeSheetView(isShowVisaTypeSheet: $isShowVisaTypeSheet, visaType: $visaType)
                        .presentationDragIndicator(.visible)
                        .presentationDetents([.height(280)])
                }
                Spacer()
                Image(systemName: "chevron.down")
            }
            Divider()
        }
    }
}


struct DateRow: View {
    let label: String
    @Binding var text: String

    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading) {
                    Text(label)
                        .foregroundStyle(.secondary)
                        .font(.system(size: 14))
                    Text("")
                        .font(.system(size: 16))
                        .padding(.bottom, 10)
                        .padding(.top, 0.5)
                        .bold()
                }
                Spacer()
                Image(systemName: "chevron.down")
            }
            Divider()
        }
    }
}

#Preview {
    @Previewable @State var visaType = ""
    @Previewable @State var isShowVisaTypeSheet = true
    let countryKeyword = "Iceland"
    let flag = countryKeyword
    
    CountrySelectionCard(countryKeyword: countryKeyword, visaType: $visaType, isShowVisaTypeSheet: $isShowVisaTypeSheet)
}
