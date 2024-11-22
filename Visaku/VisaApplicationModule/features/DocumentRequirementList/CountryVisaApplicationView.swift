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
    
    var countrySelected: String?
    var visaType: String?
    var countries: [CountryData]?
    @State var isNotificationVisible: Bool = false
    
    var trip: TripEntity?
    
    public init(
        countrySelected: String? = nil,
        visaType: String? = nil,
        countries: [CountryData]? = nil,
        trip: TripEntity? = nil
    ) {
        self.countrySelected = countrySelected
        self.visaType = visaType
        self.countries = countries
        if trip != nil {
            self.visaType = trip?.visaType
            self.countrySelected = trip?.country
            self.countries = trip?.countries
        }
        self._viewModel = StateObject(wrappedValue: CountryVisaApplicationViewModel(trip: trip))
    }
    
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel: CountryVisaApplicationViewModel
    @State private var isShowPrintSheet = false
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
                        
                        if let isCompleted = viewModel.trip?.isCompleted, !isCompleted, viewModel.completionPercentage < 100 {
                            cancelButton
                            Rectangle()
                                .frame(maxWidth: .infinity, maxHeight: 1)
                                .foregroundStyle(Color.black.opacity(0.1))
                        } else if viewModel.trip?.isCompleted == true {
                            printButton
                            downloadPDFButton
                            downloadJSONButton
                        } else {
                            confirmationButton
                        }
                        
//                        if !viewModel.isShowConfirmation {
//                            
//                        } else if !viewModel.isShowPrintDownloadButton {
//                            Rectangle()
//                                .frame(width: .infinity, height: 1)
//                                .foregroundStyle(Color.blackOpacity1)
//                                .padding(.vertical, 4)
//                            confirmationButton
//                        } else {
//                            Rectangle()
//                                .frame(width: .infinity, height: 1)
//                                .foregroundStyle(Color.blackOpacity1)
//                                .padding(.vertical, 4)
//                            
//                        }
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
                .onAppear {
                    if let visaType = visaType, let countrySelected = countrySelected, let countries = countries {
                        viewModel.saveTripData(visaType: visaType, countrySelected: countrySelected, countries: countries)
                    }
                }
                .onChange(of: viewModel.completionPercentage) { oldValue, newValue in completionHandler(newValue) }
                .sheet(isPresented: $viewModel.isIdentity) { ProfileView(isSelectProfile: true).environmentObject(viewModel) }
                .presentationDragIndicator(.visible)
                .sheet(isPresented: $viewModel.isItinerary) {
                    ItineraryActionSheet()
                        .environmentObject(viewModel)
                        .presentationDetents([.height(220)])
                        .presentationDragIndicator(.visible)
                }
                .sheet(isPresented: $viewModel.isShowPreviewVisaApplicationForm) {
                    PDFPreviewSheet(trip: viewModel.trip) }
                    .presentationDragIndicator(.visible)
                .sheet(isPresented: $viewModel.isShowJSONDownload) { JSONPreviewSheet() }
                    .presentationDragIndicator(.visible)
                .fullScreenCover(isPresented: $viewModel.isPresentingConfirmationView) { VisaApplicationFinishedView().environmentObject(viewModel) }
                .fullScreenCover(isPresented: $viewModel.isFormApplication) { ApplicationFormView().environmentObject(viewModel) }
                .fullScreenCover(isPresented: $isFormApplication) { ApplicationFormView().environmentObject(viewModel) }
                
                if viewModel.isNotificationVisible {
                    NotificationCard()
                        .offset(x: 40)
                        .padding(.horizontal)
                        .onAppear {
                            viewModel.startNotificationTimer()
                        }
                }
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
                    
                    Text("Visa \(visaType ?? "TypeError") \(countrySelected ?? "CountryError")")
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
                .padding(.bottom, 8)
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
                .padding(.bottom, 8)
                .contentShape(Rectangle())
                .onTapGesture { viewModel.isIdentity.toggle() }
            }
            
            DocumentRequirementsList().environmentObject(viewModel)
                .padding(.bottom, 8)
            
            DocumentCard(height: 114, document: "Itinerary", status: .undone)
                .padding(.horizontal)
                .padding(.bottom, 8)
                .contentShape(Rectangle())
                .onTapGesture { viewModel.isItinerary.toggle() }
            
            NavigationLink(destination: ApplicationFormView().environmentObject(viewModel)) {
                DocumentCard(height: 128, document: "Form aplikasi", status: .undone)
                    .padding(.horizontal)
            }
        }
    }
    
    private var cancelButton: some View {
        CustomButton(text: "Batalkan Pengajuan", textColor: .danger4, color: .clear, font: "Inter-SemiBold", fontSize: 17) {
            Task {
                await viewModel.deleteTrip()
                dismiss()
            }
            
        }
            .padding()
    }
    
    private var confirmationButton: some View {
        CustomButton(text: "Konfirmasi", textColor: Color.stayWhite, color: .primary5, font: "Inter-SemiBold", fontSize: 17) {
            viewModel.confirmationButtonTapped()
        }
        .padding(.horizontal)
        .padding(.bottom)
    }
    
    private var printButton: some View {
        CustomButton(text: "Print semua", textColor: .white, color: Color.primary5, font: "Inter-SemiBold", fontSize: 17, paddingHorizontal: 16, paddingVertical: 16) {
            viewModel.isShowPreviewVisaApplicationForm = true
        }
        .padding(.horizontal)
    }
    
    private var downloadPDFButton: some View {
        CustomButton(text: "Unduh PDF form", textColor: .white, color: Color.primary5, font: "Inter-SemiBold", fontSize: 17, paddingHorizontal: 16, paddingVertical: 16) {
            viewModel.isShowPreviewVisaApplicationForm = true
        }
        .padding(.horizontal)
    }
    
    private var downloadJSONButton: some View {
        CustomButton(text: "Unduh JSON form", textColor: .white, color: Color.primary5, font: "Inter-SemiBold", fontSize: 17, paddingHorizontal: 16, paddingVertical: 16                     ) {
            viewModel.isShowJSONDownload = true
        }
        .padding(.horizontal)
        .padding(.bottom)
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
            viewModel.isShowConfirmation = true
        }
    }
}

#Preview {
    CountryVisaApplicationView(countrySelected: "Italia", visaType: "turis", countries: [.init(name: "Jerman", startDate: Date.now, endDate: Date.now)])
}

struct DocumentRequirementsList: View {
    @State private var selectedDocumentIndex: Int?
    @EnvironmentObject var viewModel: CountryVisaApplicationViewModel

    var body: some View {
        LazyVGrid(columns: [GridItem(.flexible(), spacing: 16), GridItem(.flexible())], spacing: 16) {
            if let visaRequirements = viewModel.trip?.visaRequirements {
                ForEach(visaRequirements.indices, id: \.self) { index in
                    let document = visaRequirements[index]
                    DocumentCard(
                        height: 115,
                        document: document.displayName,
                        status: document.isMarked ? .done : .undone,
                        requiresMarkOnly: !document.requiresUpload
                    )
                    .contentShape(Rectangle())
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
        .presentationDetents(viewModel.showDocumentDetail ? [.height(554)] : [.height(356)])
        .presentationDragIndicator(.visible)
    }
}
