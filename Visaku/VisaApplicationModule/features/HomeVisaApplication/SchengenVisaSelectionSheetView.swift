//
//  SchengenVisaSelectionSheetView.swift
//  VisaApplicationModule
//
//  Created by Nur Nisrina on 04/11/24.
//

import SwiftUI
import UIComponentModule

struct SchengenVisaSelectionSheetView: View {
    @EnvironmentObject var viewModel: VisaHistoryViewModel
    var onDismiss: () -> Void
    
    var body: some View {
        NavigationStack{
            ScrollView {
                VStack {
                    HStack(spacing: 24) {
                        Image("schengenMap")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 110, height: 150)
                        VStack(spacing: 8) {
                            Text("Kenapa visa Schengen harus ditentukan?")
                                .font(.custom("Inter-Bold", size: 20))
                                .bold()
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .lineLimit(nil)
                                .fixedSize(horizontal: false, vertical: true)
                            Text("Kamu bisa masuk menggunakan satu visa yang sama untuk beberapa negara Uni Eropa.")
                                .font(.custom("Inter-Regular", size: 15))
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .lineLimit(nil)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                        
                    }
                    .padding()
                    Divider()
                    VStack {
                        Text("Daftar negara terpilih")
                            .font(.custom("Inter-Bold", size: 19))
                            .bold()
                            .frame(maxWidth: .infinity, alignment: .leading)
                        ForEach($viewModel.countries.indices, id: \.self) { index in
                            CountrySelectionCard(countryData: $viewModel.countries[index])
                                .environmentObject(viewModel)
                        }
                    }
                    .padding()
                    AddNewSchengenCountryCard()
                        .padding(.horizontal)
                        .environmentObject(viewModel)
                }
            }
            .scrollContentBackground(.hidden)
            .padding(.top, -40)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Penentuan visa Schengen")
                        .font(.custom("Inter-SemiBold", size: 17))
                        .bold()
                        
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        onDismiss()
                    }) {
                        Image(systemName: "xmark")
                            .font(.custom("Inter-SemiBold", size: 17))
                            .padding(10)
                            .background(Circle().fill(Color.white))
                            .foregroundColor(.black)
                            .overlay(Circle().stroke(Color.gray, lineWidth: 1))
                    }
                }
            }
            .onChange(of: viewModel.areAllCountriesFilledAndVisaTypeIsEmpty) {
                viewModel.showContinueSheet = true
            }
            .onDisappear {
                viewModel.countries = []
                viewModel.visaType = ""
            }
            .sheet(isPresented: $viewModel.showContinueSheet) {
                VStack {
                    VStack(spacing: 18) {
                        VStack(spacing: 5) {
                            Text("Visa yang kamu akan ajukan adalah")
                                .font(.custom("Inter-Regular", size: 16))
                                .foregroundStyle(.secondary)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            Text("Visa \(viewModel.visaType) \(viewModel.countryVisa)  \(Countries.schengenCountryFlags[viewModel.countryVisa] ?? "")")
                                .font(.custom("Inter-Regular", size: 20))
                                .bold()
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        
                        CustomButton(text: "Selanjutnya", color: Color(.primary5), font: "Inter-SemiBold", fontSize: 20) {
                            viewModel.navigateToCountryApplicationView()
                        }
                    }
                    .padding()
                }
                .presentationDetents([.height(150)])
            }
        }
        
    }
}

#Preview {
    @Previewable @State var countryKeyword: String = "Italia"
    @Previewable @State var visaType: String = "turis"
    let countryList = [
        "Arab Saudi", "Australia", "Bangladesh", "Bhutan",
        "China", "Jepang", "Korea Selatan", "Pakistan",
        "Schengen Area", "Taiwan"
    ]
    SchengenVisaSelectionSheetView(
        
        onDismiss: {
            
        }
    )
    .environmentObject(VisaHistoryViewModel())
}
