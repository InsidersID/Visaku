//
//  CountrySelectionCard.swift
//  VisaApplicationModule
//
//  Created by Nur Nisrina on 06/11/24.
//

import SwiftUI
import UIComponentModule

struct CountrySelectionCard: View {
    
    @EnvironmentObject var viewModel: VisaHistoryViewModel
    
    var body: some View {
        CardContainer(cornerRadius: 18) {
            
            VStack {
                let flag = Countries.schengenCountryFlags[viewModel.countryKeyword] ?? ""
                Text("\(viewModel.countryKeyword) \(flag)")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.title)
                    .bold()
                VStack {
                    VisaTypeRow(visaType: $viewModel.visaType, isShowVisaTypeSheet: $viewModel.isShowVisaTypeSheet)
                    DateRow(label: "Berangkat", text: $viewModel.visaType)
                    DateRow(label: "Pulang", text: $viewModel.visaType)
                }
                .padding(.vertical, 5)
            }
        }
    }
}

struct VisaTypeRow: View {
    @Binding var visaType: String
    @Binding var isShowVisaTypeSheet: Bool
    
    @EnvironmentObject var viewModel: VisaHistoryViewModel

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
                    VisaTypeSheet(isShowVisaTypeSheet: $isShowVisaTypeSheet, visaType: $visaType)
                        .presentationDragIndicator(.visible)
                        .presentationDetents([.height(280)])
                        .environmentObject(viewModel)
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
    @Previewable @State var isShowVisaTypeSheet = false
    let countryKeyword = "Italia"
    let flag = countryKeyword
    
    CountrySelectionCard()
        .environmentObject(VisaHistoryViewModel())
}
