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
                        ApplicationSection(title: "Riwayat", counter: 3)
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
                CountryVisaApplicationView(countrySelected: viewModel.countryKeyword, visaType: viewModel.visaType)
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
                .font(.system(size: 20))
                .bold()
                .opacity(0.5)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
            
            ForEach(0..<counter, id: \.self) { _ in
                VisaApplicationCard(visaType: "turis", country: "itali", countries: ["italy", "jerman"], visaProgressPercentage: 75, visaProgressColor: .pink) {
                    print("Card clicked")
                }
                .padding()
            }
        }
    }
}

struct EmptyStateView: View {
    var body: some View {
        VStack(spacing: 8) {
            Spacer()
            VStack {
                Image("emptyFile")
                Text("Belum ada data.")
                    .font(.system(size: 20))
                    .bold()
                Text("Yuk, ajukan visa tujuanmu di Visaku\nsekarang!")
                    .font(.system(size: 14))
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
