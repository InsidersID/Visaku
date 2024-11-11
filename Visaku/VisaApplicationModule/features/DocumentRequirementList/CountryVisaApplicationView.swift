//
//  SwiftUIView.swift
//  VisaApplicationModule
//
//  Created by hendra on 18/10/24.
//

import SwiftUI
import UIComponentModule

public struct CountryVisaApplicationView: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = CountryVisaApplicationViewModel()
    @State private var progress: Double = 10
//    var applicationList: [String] = ["Tiket Pesawat", "Reservasi Hotel", "Asuransi Medis", "Referensi Bank", "Itinerary"]
    
    
    @State var isIdentity: Bool = false
    @State var isFormApplication: Bool = false
    @State var isFlightTicket: Bool = false
    @State var isHotelReservation: Bool = false
    @State var isMedicalInsurance: Bool = false
    @State var isBankReference: Bool = false
    @State var isItinerary: Bool = false
    @State var isPassport: Bool = false
    @State var isFotokopiKartuKeluarga: Bool = false
    
    //Mark
    @State var isFotokopiKartuKeluargaMarked: Bool = false
    
    @State private var isMarkedStatus: [VisaGeneralTouristDocumentType: Bool] = [
        .fotokopiKartuKeluarga: false,
        .kartuKeluargaAsli: false,
        .fotokopiAktaKelahiranAtauSuratNikah: false,
        .paspor: false,
        .fotokopiPaspor: false,
        .pasFoto: false,
        .asuransiKesehatanPerjalanan: false,
        .buktiPemesananAkomodasi: false,
        .buktiPenerbangan: false,
        .intineraryLengkap: false,
        .rekeningKoranPribadi: false,
        .sponsor: false,
        .buktiKeuangan: false
    ]

    public init() {}
    
    public var body: some View {
        NavigationView {
            ZStack {
                ScrollView {
                    Color
                        .clear
                        .ignoresSafeArea(.all)
                    Gauge(value: progress, in: 0...100) {
                        
                    } currentValueLabel: {
                        VStack {
                            Text("\(Int(progress))%")
                            Text("Visa turis Italia")
                                .foregroundStyle(colorScheme == .dark ? Color.white : Color.black)
                                .font(.system(.title, design: .serif, weight: .semibold))
                        }
                        .foregroundStyle(.blue)
                        .padding(.bottom, 50)
                    }
                    .tint(.blue)
                    .gaugeStyle(VisaApplicationProgressStyle(gaugeSize: 300))
                    
                    Divider()
                        .padding(.bottom)
                    
                    VStack {
                        DocumentCard(height: 82, document: "Identitas", status: .undone)
                            .onTapGesture {
                                isIdentity.toggle()
                            }
                        DocumentCard(height: 122, document: "Form Aplikasi", status: .undone)
                            .onTapGesture {
                                isFormApplication.toggle()
                            }
                    }
                    .padding(.horizontal)
                    
                    DocumentRequirementsList(isMarkedStatus: $isMarkedStatus)
                    CustomButton(text: "Download", color: .blue, fontSize: 17, cornerRadius: 14, paddingHorizontal: 16, paddingVertical: 16) {
                    }
                    .padding()
                }
                
                NotificationCard()
                    .offset(x: 40, y: 0)
                
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
            .sheet(isPresented: $isIdentity) {
                ProfileView()
            }
            .sheet(isPresented: $isFormApplication) {
                Text("Form Application")
            }
            .sheet(isPresented: $isFlightTicket) {
                Text("Flight Ticket")
            }
            .sheet(isPresented: $isHotelReservation) {
                Text("Hotel Reservation")
            }
            .sheet(isPresented: $isMedicalInsurance) {
                Text("Medical Insurance")
            }
            .sheet(isPresented: $isBankReference) {
                Text("Bank Reference")
            }
            .sheet(isPresented: $isItinerary) {
                ItineraryListSheet()
            }
        }
    }
}

#Preview {
    CountryVisaApplicationView()
}

struct DocumentRequirementsList: View {
    let documents = VisaGeneralTouristDocumentType.data
    @Binding var isMarkedStatus: [VisaGeneralTouristDocumentType: Bool]
    
    var body: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())]) {
            ForEach(documents, id: \.self) { application in
                DocumentCard(
                    height: 115,
                    document: application.displayName,
                    status: .undone,
                    requiresMarkOnly: application.requiresUpload
                )
                .onTapGesture {
                    isMarkedStatus[application]?.toggle()
                }
                .sheet(isPresented: Binding(
                    get: { isMarkedStatus[application] ?? false },
                    set: { isMarkedStatus[application] = $0 }
                )) {
                    if application.requiresUpload {
                        ActionDocumentSheet(
                            documentType: application,
                            isMarked: Binding(
                                get: { isMarkedStatus[application] ?? false },
                                set: { isMarkedStatus[application] = $0 }
                            )
                        )
                        .presentationDetents([.height(356)])
                        .presentationDragIndicator(.visible)
                    } else {
                        MarkOnlyDocumentSheet(
                            documentType: application,
                            isMarked: Binding(
                                get: { isMarkedStatus[application] ?? false },
                                set: { isMarkedStatus[application] = $0 }
                            )
                        )
                        .presentationDetents([.height(356)])
                        .presentationDragIndicator(.visible)
                    }
                }
            }
        }
        .padding(.horizontal)
    }
}
