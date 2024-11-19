//
//  CountrySelectionCard.swift
//  VisaApplicationModule
//
//  Created by Nur Nisrina on 06/11/24.
//

import SwiftUI
import UIComponentModule
import RepositoryModule

struct CountrySelectionCard: View {
    @State var showCalendar: Bool = false
    @Binding var countryData: CountryData
    @EnvironmentObject var viewModel: VisaHistoryViewModel
    
    var body: some View {
        CardContainer(cornerRadius: 18) {
            VStack {
                let flag = Countries.schengenCountryFlags[countryData.name] ?? ""
                Text("\(countryData.name) \(flag)")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.custom("Inter-Bold", size: 20))
                    .foregroundStyle(Color.blackOpacity5)
                
                VStack {
                    VisaTypeRow(visaType: $viewModel.visaType, isShowVisaTypeSheet: $viewModel.isShowVisaTypeSheet)
                        .padding(.bottom)
                    
                    DateRow(label: "Berangkat", showCalendar: $showCalendar, date: $countryData.startDate)
                        .padding(.bottom)
                    
                    if showCalendar {
                        DatePickerCalendar(startDate: $countryData.startDate, endDate: $countryData.endDate, excludedDateRanges: viewModel.excludedDateRanges)
                            .padding(.bottom)
                    }
                    
                    DateRow(label: "Pulang", showCalendar: $showCalendar, date: $countryData.endDate)
                }
                .padding(.vertical, 5)
                .onChange(of: countryData.startDate) {
                    checkAndCloseCalendar()
                }
                .onChange(of: countryData.endDate) {
                    checkAndCloseCalendar()
                }
            }
        }
    }
    
    private func checkAndCloseCalendar() {
        if countryData.startDate != nil && countryData.endDate != nil {
            showCalendar = false
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
                        .foregroundStyle(Color.blackOpacity3)
                        .font(.custom("Inter-Regular", size: 14))
                    Text("\(visaType == "" ? "" : "Visa \(visaType)")")
                        .font(.custom("Inter-SemiBold", size: 16))
                        .foregroundStyle(Color.blackOpacity4)
                        .padding(.bottom, 10)
                        .padding(.top, 0.5)
                }
                
                Spacer()
                
                Image(systemName: "chevron.down")
                    .foregroundStyle(Color.blackOpacity3)
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
            
            Rectangle()
                .frame(width: .infinity, height: 1)
                .foregroundStyle(Color.blackOpacity2)
        }
    }
}


struct DateRow: View {
    let label: String
    @Binding var showCalendar: Bool
    @Binding var date: Date?
    
    @EnvironmentObject var viewModel: VisaHistoryViewModel

    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading) {
                    Text(label)
                        .foregroundStyle(Color.blackOpacity3)
                        .font(.custom("Inter-Regular", size: 14))
                    Text(date?.formatted(date: .abbreviated, time: .omitted) ?? "")
                        .font(.custom("Inter-SemiBold", size: 16))
                        .foregroundStyle(Color.blackOpacity4)
                        .padding(.bottom, 10)
                        .padding(.top, 0.5)
                }
                
                Spacer()
                
                Image(systemName: showCalendar ? "chevron.up" : "chevron.down")
                    .foregroundStyle(Color.blackOpacity3)
            }
            .contentShape(Rectangle())
            .onTapGesture {
                showCalendar.toggle()
            }
            
            Rectangle()
                .frame(width: .infinity, height: 1)
                .foregroundStyle(Color.blackOpacity2)
        }
    }
}

#Preview {
    @Previewable @State var countryData = CountryData(name: "Italia")
    
    CountrySelectionCard(countryData: $countryData)
        .environmentObject(VisaHistoryViewModel())
}
