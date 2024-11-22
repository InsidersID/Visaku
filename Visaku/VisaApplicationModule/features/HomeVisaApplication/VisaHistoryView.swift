//
//  VisaHistoryView.swift
//  VisaApplicationModule
//
//  Created by Nur Nisrina on 18/10/24.
//

import SwiftUI
import UIComponentModule

public struct VisaHistoryView: View {
    @EnvironmentObject var viewModel: VisaHistoryViewModel
    @Environment(ProfileViewModel.self) var profileViewModel
    
    public var body: some View {
        @Bindable var profileViewModel = profileViewModel
        NavigationStack {
            VStack {
                ScrollView {
                    VisaApplicationHeader()
                        .environmentObject(viewModel)
                    VStack {
                        if viewModel.hasData {
                            ApplicationSection(title: "Belum selesai")
                                .padding(.horizontal, 20)
                                .environmentObject(viewModel)
                                .environment(profileViewModel)
                            ApplicationSection(title: "Riwayat")
                                .padding(.horizontal, 20)
                                .environmentObject(viewModel)
                                .environment(profileViewModel)
                        } else {
                            EmptyStateView()
                        }
                    }
                }
                .onAppear {
                    viewModel.visaType = ""
                    viewModel.countries.removeAll()
                    viewModel.fetchVisaHistoryInProgressData()
                    viewModel.fetchVisaHistoryCompletedData()
                }
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
                    CountryVisaApplicationView(countrySelected: viewModel.countryVisa, visaType: viewModel.visaType, countries: viewModel.countries)
                        .environment(profileViewModel)
                        .navigationBarBackButtonHidden()
                }
            }
            .ignoresSafeArea(edges: .all)
        }
    }
}

struct ApplicationSection: View {
    @EnvironmentObject var viewModel: VisaHistoryViewModel
    @Environment(ProfileViewModel.self) var profileViewModel
    let title: String
    
    var body: some View {
        @Bindable var profileViewModel = profileViewModel
        VStack(spacing: 12) {
            if title == "Belum selesai" {
                switch viewModel.fetchVisaHistoryUncompleted {
                case .idle:
                    Text("Idle")
                case .loading:
                    ProgressView()
                case .error:
                    Text("Something wrong")
                case .success:
                    if let visaHistoryUncompleted = viewModel.tripUncompleteList, !visaHistoryUncompleted.isEmpty {
                        Text(title)
                            .font(.custom("Inter-SemiBold", size: 20))
                            .opacity(0.5)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        ForEach(visaHistoryUncompleted) { trip in
                            let tripData = TripDataUIModel(from: trip)
                            NavigationLink {
                                CountryVisaApplicationView(trip: trip)
                                    .environment(profileViewModel)
                                    .navigationBarBackButtonHidden()
                            } label: {
                                VisaApplicationCard(isCompleted: tripData.isCompleted, visaType: tripData.visaType, country: tripData.country, countries: tripData.countries, visaProgressPercentage: tripData.percentage, visaProgressColor: Color.danger5, createdAt: tripData.date) {
                                    
                                }
                            }
                        }
                    } else {
                        EmptyView()
                    }
                }
            } else if title == "Riwayat" {
                switch viewModel.fetchVisaHistoryCompleted {
                case .idle:
                    Text("Idle")
                case .loading:
                    ProgressView()
                case .error:
                    Text("Something wrong")
                case .success:
                    Text(title)
                        .font(.custom("Inter-SemiBold", size: 20))
                        .opacity(0.5)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    if let visaHistoryCompleted = viewModel.tripCompleteList, !visaHistoryCompleted.isEmpty{
                        ForEach(visaHistoryCompleted) { trip in
                            let tripData = TripDataUIModel(from: trip)
                            NavigationLink {
                                CountryVisaApplicationView(trip: trip)
                                    .environment(profileViewModel)
                                    .navigationBarBackButtonHidden()
                            } label: {
                                VisaApplicationCard(isCompleted: tripData.isCompleted, visaType: tripData.visaType, country: tripData.country, countries: tripData.countries, visaProgressPercentage: tripData.percentage, visaProgressColor: Color.success6, createdAt: tripData.date) {
                                   
                                }
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
