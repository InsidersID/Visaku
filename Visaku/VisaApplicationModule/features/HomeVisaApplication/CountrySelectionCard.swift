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
                    
                    DateRow(label: "Berangkat", date: $viewModel.startDate)
                    
                    if viewModel.showCalendar {
                        DatePickerCalendar(startDate: $viewModel.startDate, endDate: $viewModel.endDate)
                    }
                    
                    DateRow(label: "Pulang", date: $viewModel.endDate)
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
                        .font(.custom("Inter-Regular", size: 14))
                    Text("\(visaType == "" ? "" : "Visa \(visaType)")")
                        .font(.custom("Inter-SemiBold", size: 16))
                        .padding(.bottom, 10)
                        .padding(.top, 0.5)
                }
                
                Spacer()
                
                Image(systemName: "chevron.down")
            }
            .contentShape(Rectangle())
            .onTapGesture {
                isShowVisaTypeSheet = true
            }
            .sheet(isPresented: $isShowVisaTypeSheet) {
                VisaTypeSheet(isShowVisaTypeSheet: $isShowVisaTypeSheet, visaType: $visaType)
                    .presentationDragIndicator(.visible)
                    .presentationDetents([.height(280)])
                    .environmentObject(viewModel)
            }
            
            Divider()
        }
    }
}


struct DateRow: View {
    let label: String
    @Binding var date: Date?
    
    @EnvironmentObject var viewModel: VisaHistoryViewModel

    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading) {
                    Text(label)
                        .foregroundStyle(.secondary)
                        .font(.custom("Inter-Regular", size: 14))
                    Text("")
                        .font(.custom("Inter-SemiBold", size: 16))
                        .padding(.bottom, 10)
                        .padding(.top, 0.5)
                        .bold()
                }
                
                Spacer()
                
                Image(systemName: viewModel.showCalendar ? "chevron.up" : "chevron.down")
            }
            .contentShape(Rectangle())
            .onTapGesture {
                viewModel.showCalendar.toggle()
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
