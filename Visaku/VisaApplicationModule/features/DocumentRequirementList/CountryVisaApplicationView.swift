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
    var countries: [CountryData]
    
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.dismiss) private var dismiss
    @StateObject var viewModel = CountryVisaApplicationViewModel()
    @State private var isShowPrintSheet = false
    @State private var isItinerary = false
    @State private var isFormApplication = false
    
    public var body: some View {
        NavigationStack {
            ZStack {
                Color.clear.ignoresSafeArea()
                ScrollView {
                    
                    VStack {
                        progressGauge
                            .padding(.top)
                        
                        Divider()
                            .padding(.bottom)
                        
                        documentCards
                        cancelButton
                    }
                }
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        Text("Pengajuan")
                            .font(.custom("Inter-SemiBold", size: 24))
                    }
                    ToolbarItem(placement: .topBarLeading) {
                        Button(action: {
                            dismiss()
                        }) {
                            Image(systemName: "chevron.backward")
                                .font(.custom("Inter-SemiBold", size: 17))
                                .padding(10)
                                .background(Circle().fill(Color.white))
                                .foregroundColor(.black)
                                .overlay(Circle().stroke(Color.gray, lineWidth: 1))
                        }
                    }
                }
                .onAppear { viewModel.saveTripData(visaType: visaType, countrySelected: countrySelected, countries: countries) }
                .onChange(of: viewModel.completionPercentage) { completionHandler($0) }
                .sheet(isPresented: $viewModel.isIdentity) { ProfileView(isSelectProfile: true).environmentObject(viewModel) }
                .sheet(isPresented: $isItinerary) { ItineraryListSheet() }
                .sheet(isPresented: $isShowPrintSheet) { printSheet }
                .fullScreenCover(isPresented: $isFormApplication) { ApplicationFormView().environmentObject(viewModel) }
                
                NotificationCard()
                    .offset(x: 40)
                    .padding(.horizontal)
            }
        }
        
    }
    
    private var progressGauge: some View {
        VStack {
            Gauge(value: viewModel.completionPercentage, in: 0...100) {
                EmptyView()
            } currentValueLabel: {
                VStack {
                    Text("\(Int(viewModel.completionPercentage))%")
                        .font(.custom("Inter-Bold", size: 64))
                        .foregroundStyle(Color.primary5)
                    
                    Text("Visa \(visaType) \(countrySelected)")
                        .foregroundStyle(Color.blackOpacity5)
                        .font(.custom("Inter-Medium", size: 20))
                }
                .padding(.bottom, 50)
            }
            .tint(.primary5)
            .gaugeStyle(VisaApplicationProgressStyle(gaugeSize: 240))
        }
    }
    
    private var documentCards: some View {
        VStack {
            if viewModel.trip?.account == nil {
                CardContainer(cornerRadius: 24) {
                    HStack {
                        Text("Identitas")
                            .font(.custom("Inter-SemiBold", size: 16))
                        
                        Spacer()
                        
                        Image(systemName: "chevron.down")
                            .fontWeight(.bold)
                    }
                    .frame(height: 47)
                }
                .padding(.horizontal)
                .contentShape(Rectangle())
                .onTapGesture { viewModel.isIdentity.toggle() }
            } else {
                CardContainer(cornerRadius: 24) {
                    VStack {
                        HStack {
                            Text("Identitas")
                                .font(.custom("Inter-Bold", size: 14))
                                .foregroundStyle(Color.blackOpacity3)
                                .padding(.bottom, 8)
                            
                            Spacer()
                        }
                        
                        HStack {
                            Text(viewModel.trip?.account?.username ?? "Error")
                                .font(.custom("Inter-SemiBold", size: 16))
                            
                            Spacer()
                            
                            Image(systemName: "chevron.down")
                                .fontWeight(.bold)
                        }
                    }
                    .frame(height: 91)
                }
                .padding(.horizontal)
                .contentShape(Rectangle())
                .onTapGesture { viewModel.isIdentity.toggle() }
            }
            
            DocumentRequirementsList().environmentObject(viewModel)
            
            DocumentCard(height: 114, document: "Itinerary", status: .undone)
                .padding(.horizontal)
                .onTapGesture { isItinerary.toggle() }
            
            NavigationLink(destination: ApplicationFormView().environmentObject(viewModel)) {
                DocumentCard(height: 128, document: "Form Aplikasi", status: .undone)
                    .padding(.horizontal)
            }
        }
    }
    
    private var cancelButton: some View {
        CustomButton(text: "Batalkan Pengajuan", textColor: .danger4, color: .clear, font: "Inter-SemiBold", fontSize: 17) {}
            .padding()
    }
    
    private var backButton: some ToolbarContent {
        ToolbarItem(placement: .topBarLeading) {
            Button(action: { dismiss() }) {
                Image(systemName: "chevron.left.circle").foregroundStyle(.black)
            }
        }
    }
    
    private func completionHandler(_ percentage: Double) {
        if percentage == 100 {
            isShowPrintSheet = true
        }
    }
    
    private var printSheet: some View {
        CustomButton(text: "Print semua", color: .primary5, font: "Inter-SemiBold", fontSize: 17, cornerRadius: 14, paddingHorizontal: 16, paddingVertical: 16) {}
            .padding()
            .presentationDetents([.height(100)])
    }
}

#Preview {
    CountryVisaApplicationView(countrySelected: "Italia", visaType: "turis", countries: [.init(name: "Jerman", startDate: .now, endDate: .now)])
}

struct DocumentRequirementsList: View {
    @State private var selectedDocumentIndex: Int?
    @EnvironmentObject var viewModel: CountryVisaApplicationViewModel

    var body: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())]) {
            if let visaRequirements = viewModel.trip?.visaRequirements {
                ForEach(visaRequirements.indices, id: \.self) { index in
                    let document = visaRequirements[index]
                    DocumentCard(
                        height: 115,
                        document: document.displayName,
                        status: document.isMarked ? .done : .undone,
                        requiresMarkOnly: !document.requiresUpload
                    )
                    .onTapGesture {
                        selectedDocumentIndex = index
                    }
                }
            }
        }
        .padding(.horizontal)
        .sheet(item: selectedDocumentBinding) { document in
            DocumentSheet(
                documentType: document,
                isMarked: Binding(
                    get: { document.isMarked },
                    set: { newValue in
                        if let index = selectedDocumentIndex {
                            viewModel.trip?.visaRequirements?[index].isMarked = newValue
                        }
                    }
                )
            )
            .environmentObject(viewModel)
        }
    }

    private var selectedDocumentBinding: Binding<VisaRequirement?> {
        Binding<VisaRequirement?>(
            get: {
                guard let index = selectedDocumentIndex,
                      let visaRequirements = viewModel.trip?.visaRequirements,
                      index < visaRequirements.count else {
                    return nil
                }
                return visaRequirements[index]
            },
            set: { _ in
                selectedDocumentIndex = nil
            }
        )
    }
}

struct DocumentSheet: View {
    var documentType: VisaRequirement
    @Binding var isMarked: Bool
    @EnvironmentObject var viewModel: CountryVisaApplicationViewModel
    
    var body: some View {
        Group {
            if documentType.requiresUpload {
                ActionDocumentSheet(documentType: documentType, isMarked: $isMarked)
                    .environmentObject(viewModel)
            } else {
                MarkOnlyDocumentSheet(documentType: documentType, isMarked: $isMarked)
                    .environmentObject(viewModel)
            }
        }
        .presentationDetents([.height(356)])
        .presentationDragIndicator(.visible)
    }
}
