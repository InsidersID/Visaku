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
                    Color.clear.ignoresSafeArea(.all)
                    
                    // Extracted Progress View
                    progressView
                    
                    Divider()
                        .padding(.bottom)
                    
                    // Extracted Document Section
                    documentSection
                    
                    // Extracted Download Button
                    downloadButton
                }
                
                NotificationCard()
                    .offset(x: 40, y: 0)
            }
            .navigationTitle("Pengajuan")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                leadingToolbarItem
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

// Preview and ShareSheet struct remain unchanged

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
