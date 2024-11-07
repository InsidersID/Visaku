//
//  SwiftUIView.swift
//  VisaApplicationModule
//
//  Created by hendra on 18/10/24.
//

import SwiftUI
import UIComponentModule
import ProfileModule

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
                    
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())]) {
                        ForEach(applicationList, id: \.self) { application in
                            DocumentCard(height: application == "Itinerary" ? 82 : 115, document: application, status: .undone)
                                .onTapGesture {
                                    switch application {
                                    case "Tiket Pesawat":
                                        isFlightTicket.toggle()
                                    case "Reservasi Hotel":
                                        isHotelReservation.toggle()
                                    case "Asuransi Medis":
                                        isMedicalInsurance.toggle()
                                    case "Referensi Bank":
                                        isBankReference.toggle()
                                    case "Itinerary":
                                        isItinerary.toggle()
                                    default:
                                        EmptyView()
                                    }
                                }
                        }
                    }
                    .padding(.horizontal)
                    CustomButton(text: "Download", color: .blue, font: 17, cornerRadius: 14, paddingHorizontal: 16, paddingVertical: 16) {
                        downloadJSON()
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
            .sheet(isPresented: $showingShareSheet) {
                if let fileURL = fileURL {
                    ShareSheet(activityItems: [fileURL])
                }
            }
        }
    }
    
    private func downloadJSON() {
        // Locate the JSON file in your app bundle
        if let bundlePath = Bundle.main.url(forResource: "visa", withExtension: "json") {
            
            // Get the app's document directory
            let fileManager = FileManager.default
            let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first
            
            // Create a destination URL in the documents directory
            if let documentsURL = documentsURL {
                let destinationURL = documentsURL.appendingPathComponent("visa.json")
                
                // Check if the file already exists in the documents directory
                if fileManager.fileExists(atPath: destinationURL.path) {
                    print("File already exists at \(destinationURL.path)")
                    fileURL = destinationURL
                    showingShareSheet = true
                } else {
                    do {
                        // Copy the file from the bundle to the documents directory
                        try fileManager.copyItem(at: bundlePath, to: destinationURL)
                        print("File saved to \(destinationURL.path)")
                        
                        // Set the URL for sharing or viewing
                        fileURL = destinationURL
                        showingShareSheet = true
                    } catch {
                        print("Error copying file: \(error.localizedDescription)")
                    }
                }
            }
        } else {
            print("File not found in the bundle.")
        }
    }
}

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
