//
//  VisaHistoryView.swift
//  VisaApplicationModule
//
//  Created by Nur Nisrina on 18/10/24.
//

import SwiftUI
import UIComponentModule

public struct VisaHistoryView: View {
    @StateObject var viewModel: VisaHistoryViewModel = VisaHistoryViewModel()
    
    public var body: some View {
        NavigationStack {
            VStack {
                VisaApplicationHeader()
                    .environmentObject(viewModel)
                
                if viewModel.hasData {
                    ScrollView {
                        ApplicationSection(title: "Belum selesai", counter: 4)
                            .environmentObject(viewModel)
                        ApplicationSection(title: "Riwayat", counter: 3)
                            .environmentObject(viewModel)
                    }
                } else {
                    EmptyStateView()
                }
            }
            .ignoresSafeArea(edges: .all)
            .sheet(isPresented: $viewModel.isShowChooseCountrySheet) {
                CountrySelectionSheetView(
                    onDismiss: {
                        viewModel.isShowChooseCountrySheet = false
                    }
                )
                .environmentObject(viewModel)
                .presentationDragIndicator(.visible)
                
            }
            .navigationDestination(isPresented: $viewModel.isShowCountryApplicationView) {
                CountryVisaApplicationView(countrySelected: viewModel.countryKeyword, visaType: viewModel.visaType, countries: [.init(name: viewModel.countryKeyword, startDate: .now, endDate: .now)])
                    .navigationBarBackButtonHidden()
            }
        }
    }
}

struct ApplicationSection: View {
    let title: String
    let counter: Int
    
    var body: some View {
        VStack(spacing: 0) {
            Text(title)
                .font(.custom("Inter-SemiBold", size: 20))
                .bold()
                .opacity(0.5)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(12)
            
            ForEach(0..<counter, id: \.self) { _ in
                VisaApplicationCard(visaType: "turis", country: "itali", countries: ["italy", "jerman"], visaProgressPercentage: 75, visaProgressColor: .pink) {
                    print("Card clicked")
                }
                .padding(.horizontal)
                .padding(.vertical, 4)
            }
        }
    }
}

struct EmptyStateView: View {
    var body: some View {
        VStack(spacing: 8) {
            Spacer()
            VStack(spacing: 5) {
                Image("emptyFile")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .padding()
                Text("Belum ada data.")
                    .font(.custom("Inter-Bold", size: 20))
                    .bold()
                Text("Yuk, ajukan visa tujuanmu ")
                    .font(.custom("Inter-Regular", size: 16))
                    .multilineTextAlignment(.center)
                    .opacity(0.75)
                Text("di Visaku sekarang!")
                    .font(.custom("Inter-Regular", size: 16))
                    .multilineTextAlignment(.center)
                    .opacity(0.75)
            }
            .padding(.bottom, 70)
            .padding(.horizontal)
            Spacer()
        }
    }
}


#Preview {
    VisaHistoryView()
        .environmentObject(VisaHistoryViewModel())
}
