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
    var applicationList: [String] = ["Tiket Pesawat", "Reservasi Hotel", "Asuransi Medis", "Referensi Bank", "Itinerary"]
    
    @State var isIdentity: Bool = false
    @State var isFormApplication: Bool = false
    @State var isFlightTicket: Bool = false
    @State var isHotelReservation: Bool = false
    @State var isMedicalInsurance: Bool = false
    @State var isBankReference: Bool = false
    @State var isItinerary: Bool = false
    
    @State private var showingShareSheet = false
    @State private var fileURL: URL?
    
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
            .sheet(isPresented: $showingShareSheet) {
                if let fileURL = fileURL {
                    ShareSheet(activityItems: [fileURL])
                }
            }
        }
    }
    
    // MARK: - Components

    private var progressView: some View {
        Gauge(value: progress, in: 0...100) { }
            currentValueLabel: {
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
    }
    
    private var documentSection: some View {
        VStack {
            DocumentCard(height: 82, document: "Identitas", status: .undone)
                .onTapGesture { isIdentity.toggle() }
            
            DocumentCard(height: 122, document: "Form Aplikasi", status: .undone)
                .onTapGesture { isFormApplication.toggle() }
            
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())]) {
                ForEach(applicationList, id: \.self) { application in
                    DocumentCard(height: application == "Itinerary" ? 82 : 115, document: application, status: .undone)
                        .onTapGesture {
                            switch application {
                            case "Tiket Pesawat": isFlightTicket.toggle()
                            case "Reservasi Hotel": isHotelReservation.toggle()
                            case "Asuransi Medis": isMedicalInsurance.toggle()
                            case "Referensi Bank": isBankReference.toggle()
                            case "Itinerary": isItinerary.toggle()
                            default: break
                            }
                        }
                }
            }
            .padding(.horizontal)
        }
        .padding(.horizontal)
    }
    
    private var downloadButton: some View {
        CustomButton(text: "Download", color: .blue, fontSize: 17, cornerRadius: 14, paddingHorizontal: 16, paddingVertical: 16) {
            downloadJSON()
        }
        .padding()
    }
    
    private var leadingToolbarItem: some ToolbarContent {
        ToolbarItem(placement: .topBarLeading) {
            Button { dismiss() } label: {
                Image(systemName: "chevron.left.circle")
                    .foregroundStyle(.black)
            }
        }
    }
    
    private func downloadJSON() {
        if let bundlePath = Bundle.main.url(forResource: "visa", withExtension: "json"),
           let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let destinationURL = documentsURL.appendingPathComponent("visa.json")
            
            if FileManager.default.fileExists(atPath: destinationURL.path) {
                fileURL = destinationURL
                showingShareSheet = true
            } else {
                do {
                    try FileManager.default.copyItem(at: bundlePath, to: destinationURL)
                    fileURL = destinationURL
                    showingShareSheet = true
                } catch {
                    print("Error copying file: \(error.localizedDescription)")
                }
            }
        } else {
            print("File not found in the bundle.")
        }
    }
}

// Preview and ShareSheet struct remain unchanged

#Preview {
    CountryVisaApplicationView()
}

struct ShareSheet: UIViewControllerRepresentable {
    var activityItems: [Any]

    func makeUIViewController(context: Context) -> UIActivityViewController {
        return UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {
        // No update needed
    }
}
