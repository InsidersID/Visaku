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
                        ApplicationSection(title: "Belum selesai")
                            .environmentObject(viewModel)
                        ApplicationSection(title: "Riwayat")
                            .environmentObject(viewModel)
                    }
                } else {
                    EmptyStateView()
                }
            }
            .onAppear {
                viewModel.fetchVisaHistoryInProgressData()
                viewModel.fetchVisaHistoryCompletedData()
                
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
    @EnvironmentObject var viewModel: VisaHistoryViewModel
    let title: String
    
    var body: some View {
        VStack(spacing: 0) {
            Text(title)
                .font(.custom("Inter-SemiBold", size: 20))
                .bold()
                .opacity(0.5)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(12)
            
//            VisaApplicationCard(visaType: "turis", country: "itali", countries: ["italy", "jerman"], visaProgressPercentage: 75, visaProgressColor: .pink) {
//                print("Card clicked")
//            }
//            .padding(.horizontal)
//            .padding(.vertical, 4)
            if title == "Belum selesai" {
//                VisaApplicationCard(visaType: "turis", country: "itali", countries: ["italy", "jerman"], visaProgressPercentage: 75, visaProgressColor: .pink) {
//                        print("Card clicked")
//                    }
//                    .padding(.horizontal)
//                    .padding(.vertical, 4)
                switch viewModel.fetchVisaHistoryUncompleted {
                case .idle:
                    Text("Idle")
                case .loading:
                    ProgressView()
                case .error:
                    Text("Something wrong")
                case .success:
                    if let visaHistoryUncompleted = viewModel.tripUncompleteList{
                        ForEach(visaHistoryUncompleted) { trip in
                            let tripData = TripDataUIModel(from: trip)
                            VisaApplicationCard(visaType: tripData.visaType, country: tripData.country, countries: tripData.countries, visaProgressPercentage: tripData.percentage, visaProgressColor: .red, createdAt: tripData.date) {
                                print("trigger card")
                            }
                        }
                    }
                }
            } else if title == "Selesai" {
                switch viewModel.fetchVisaHistoryCompleted {
                case .idle:
                    Text("Idle")
                case .loading:
                    ProgressView()
                case .error:
                    Text("Something wrong")
                case .success:
                    if let visaHistoryCompleted = viewModel.tripCompleteList{
                        ForEach(visaHistoryCompleted) { trip in
                            let tripData = TripDataUIModel(from: trip)
                            VisaApplicationCard(visaType: tripData.visaType, country: tripData.country, countries: tripData.countries, visaProgressPercentage: tripData.percentage, visaProgressColor: .green, createdAt: tripData.date) {
                                print("trigger card")
                            }
                        }
                    }
                }
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
