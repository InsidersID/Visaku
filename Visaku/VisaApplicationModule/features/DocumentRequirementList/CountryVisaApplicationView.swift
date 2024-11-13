//
//  SwiftUIView.swift
//  VisaApplicationModule
//
//  Created by hendra on 18/10/24.
//

import SwiftUI
import UIComponentModule
import RepositoryModule

public struct CountryVisaApplicationView: View {
    
    var countrySelected: String
    var visaType: String
    
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = CountryVisaApplicationViewModel()
    @State private var progress: Double = 0
    @State private var isShowPrintSheet = false
    
    @State var isIdentity: Bool = false
    @State var isItinerary: Bool = false
    @State var isFormApplication: Bool = false
    
    public var body: some View {
        
        NavigationStack {
            ZStack {
                ScrollView {
                    Color
                        .clear
                        .ignoresSafeArea(.all)
                    VStack {
                        
                        Gauge(value: viewModel.completionPercentage, in: 0...100) {
                            
                        } currentValueLabel: {
                            VStack {
                                Text("\(Int(viewModel.completionPercentage))%")
                                Text("Visa \(visaType) \(countrySelected)")
                                    .foregroundStyle(colorScheme == .dark ? Color.white : Color.black)
                                    .font(.custom("Inter-Medium", size: 20))
                            }
                            .foregroundStyle(.blue)
                            .padding(.bottom, 50)
                        }
                        .tint(.blue)
                        .gaugeStyle(VisaApplicationProgressStyle(gaugeSize: 300))
                    }
                    
                    Divider()
                        .padding(.bottom)
                    
                    DocumentCard(height: 82, document: "Identitas", status: .undone)
                        .padding(.horizontal)
                        .onTapGesture {
                            isIdentity.toggle()
                        }
                    DocumentRequirementsList()
                        .environmentObject(viewModel)
                    DocumentCard(height: 114, document: "Itinerary", status: .undone)
                        .padding(.horizontal)
                        .onTapGesture {
                            isItinerary.toggle()
                        }
                    NavigationLink(destination: ApplicationFormView().environmentObject(viewModel)) {
                        DocumentCard(height: 128, document: "Form Aplikasi", status: .undone)
                            .padding(.horizontal)
                    }
                    
                    CustomButton(text: "Batalkan Pengajuan", textColor: .danger4, color: .clear, font: "Inter-SemiBold", fontSize: 17) {
                        
                    }
                    .padding()
                
                    NotificationCard()
                        .offset(x: 40, y: 0)
                    .padding(.horizontal)
                    
                }
                .navigationTitle("Pengajuan")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button {
                            dismiss()
                        } label: {
                            Image(systemName: "chevron.left.circle")
                                .foregroundStyle(.black)
                        }
                    }
                }
                .onAppear {
                    viewModel.saveTripData(visaType: visaType, countrySelected: countrySelected)
                }
                .onChange(of: viewModel.completionPercentage) {
                    if viewModel.completionPercentage == 100 {
                        isShowPrintSheet = true
                    }
                }
                .sheet(isPresented: $isIdentity) {
                    ProfileView()
                }
                .sheet(isPresented: $isItinerary) {
                    ItineraryListSheet()
                }
                .sheet(isPresented: $isShowPrintSheet) {
                    CustomButton(text: "Print semua", color: .primary5, font: "Inter-SemiBold", fontSize: 17, cornerRadius: 14, paddingHorizontal: 16, paddingVertical: 16) {
                    }
                    .padding()
                    .presentationDetents([.height(100)])
                }
                //                .sheet(isPresented: $isFormApplication) {
                //                    ApplicationFormView()
                //                        .environmentObject(viewModel)
                //                }
                .fullScreenCover(isPresented: $isFormApplication) {
                    ApplicationFormView()
                        .environmentObject(viewModel)
                }
                
                NotificationCard()
                    .offset(x: 40, y: 0)
            }
        }
    }
}

#Preview {
    CountryVisaApplicationView(countrySelected: "Italia", visaType: "turis")
}

struct DocumentRequirementsList: View {
    @State private var selectedDocument: VisaRequirement?
    @EnvironmentObject var viewModel: CountryVisaApplicationViewModel
    
    var body: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())]) {
            if let visaRequirements = viewModel.trip?.visaRequirements {
                ForEach(visaRequirements.indices, id: \.self) { index in
                    DocumentCard(
                        height: 115,
                        document: visaRequirements[index].displayName,
                        status: visaRequirements[index].isMarked ? .done : .undone,
                        requiresMarkOnly: visaRequirements[index].requiresUpload
                    )
                    .onTapGesture {
                        selectedDocument = visaRequirements[index]
                    }
                    .sheet(item: $selectedDocument) { document in
                        DocumentSheet(
                            documentType: document,
                            isMarked: Binding(
                                get: { document.isMarked },
                                set: { newValue in
                                    if let index = visaRequirements.firstIndex(where: { $0.id == document.id }) {
                                        viewModel.trip?.visaRequirements?[index].isMarked = newValue
                                    }
                                    selectedDocument = nil
                                }
                            )
                        )
                        .environmentObject(viewModel)
                    }
                }
            }
        }
        .padding(.horizontal)
    }
}

struct DocumentSheet: View {
    var documentType: VisaRequirement
    @Binding var isMarked: Bool
    @EnvironmentObject var viewModel: CountryVisaApplicationViewModel
    
    var body: some View {
        if documentType.requiresUpload {
            ActionDocumentSheet(
                documentType: documentType,
                isMarked: $isMarked
            )
            .presentationDetents([.height(356)])
            .presentationDragIndicator(.visible)
            .environmentObject(viewModel)
        } else {
            MarkOnlyDocumentSheet(
                documentType: documentType,
                isMarked: $isMarked
            )
            .presentationDetents([.height(356)])
            .presentationDragIndicator(.visible)
            .environmentObject(viewModel)
        }
    }
}

