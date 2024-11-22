//
//  ItineraryListSheet.swift
//  VisaApplicationModule
//
//  Created by hendra on 18/10/24.
//

import SwiftUI
import UIComponentModule
import OpenAI

struct ItineraryListSheet: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var viewModel: CountryVisaApplicationViewModel
    @State var aiManager: AIGeneratorController = AIGeneratorController()
    @State private var itinerary: Itinerary = Itinerary(days: [])
    
    @State var isTravelPreviewPDF: Bool = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    ScrollView {
                        VStack {
                            if itinerary.days.isEmpty {
                                Text("Loading itinerary...")
                            } else {
                                ForEach(itinerary.days) { day in
                                    ItineraryCard(day: day)
                                }
                            }
                        }
                        Spacer()
                    }
                    .onAppear {
                        let countries = viewModel.trip?.countries ?? []
                        let countriesWithHotels = countries.filter { !$0.hotels.isEmpty }
                        let messageContent = countriesWithHotels.map { country in
                            let hotelDetails = country.hotels.map { hotel in
                                "- \(hotel.name): \(hotel.stayPeriod)"
                            }.joined(separator: "\n")
                            return """
                                \(country.name):
                                \(hotelDetails)
                                """
                        }.joined(separator: "\n\n")
                        aiManager.sendNewMessage(content: messageContent) { response in
                            if let response = response {
                                print("AI Response : \(response)")
                                loadItinerary(json: response)
                            } else {
                                print("Failed to fetch response.")
                            }
                        }
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 150)
                }
                VStack {
                    ButtonsView(isTravelPreviewPDF: $isTravelPreviewPDF)
                }
                .ignoresSafeArea(.all)
            }
            .navigationBarBackButtonHidden()
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Itinerary")
                        .font(.system(size: 24))
                        .bold()
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .fontWeight(.semibold)
                            .font(.system(size: 17))
                            .padding(10)
                            .background(Circle().fill(Color.white))
                            .foregroundColor(.black)
                            .overlay(Circle().stroke(Color.gray, lineWidth: 1))
                    }
                }
            }
            .navigationDestination(isPresented: $isTravelPreviewPDF) {
                TravelItineraryPdfPreview(itinerary: $itinerary)
                    .environmentObject(viewModel)
            }
        }
        
    }
    
    func loadItinerary(json: String) {
        guard let jsonData = json.data(using: .utf8) else {
            print("Invalid JSON string.")
            return
        }
        
        do {
            let rawDictionary = try JSONDecoder().decode([String: Day].self, from: jsonData)
            let sortedDays = Array(rawDictionary.values).sorted { $0.date < $1.date }
            let decodedItinerary = Itinerary(days: sortedDays)
            
            DispatchQueue.main.async {
                self.itinerary = decodedItinerary
            }
        } catch {
            print("Error decoding JSON: \(error)")
        }
    }
}


struct ButtonsView: View {
    @Binding var isTravelPreviewPDF: Bool
    var body: some View {
        VStack {
            Spacer()
            VStack {
                CustomButton(text: "Preview PDF", color: .blue, font: "Inter-SemiBold", fontSize: 17, cornerRadius: 12, paddingHorizontal: 8, paddingVertical: 16) {
                    isTravelPreviewPDF.toggle()
                }
                .font(.custom("Inter-SemiBold", size: 20))
                
                CustomButton(text: "Generate ulang", textColor: .blue, color: .white, font: "Inter-SemiBold", fontSize: 17, cornerRadius: 12, paddingHorizontal: 8, paddingVertical: 16) {
                    isTravelPreviewPDF.toggle()
                }
                .padding(.bottom, 15)
            }
            .padding()
        }
    }
    
}

struct ItineraryCard: View {
    @State var day: Day
    
    var body: some View {
        CardContainer(cornerRadius: 24) {
            VStack(alignment: .leading) {
                HStack {
                    Text("\(day.title)")
                        .font(.custom("Inter-SemiBold", size: 20))
                        .font(.largeTitle)
                        .bold()
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Spacer()
                    Image(systemName: "pencil")
                        .font(.system(size: 20))
                    
                }
                Text("\(day.date)")
                    .font(.custom("Inter-SemiBold", size: 12))
                    .bold()
                    .padding(.bottom, 2)
                Text("Morning")
                Text("• \(day.morning.placeName)")
                    .font(.custom("Inter-Regular", size: 15))
                Text("Afternoon")
                Text("• \(day.afternoon.placeName)")
                    .font(.custom("Inter-Regular", size: 15))
                Text("Night")
                Text("• \(day.night.placeName)")
                    .font(.custom("Inter-Regular", size: 15))
            }
        }
        .padding(.vertical, 8)
    }
}

#Preview {
    @Previewable @ObservedObject var viewModel: CountryVisaApplicationViewModel = CountryVisaApplicationViewModel()
    ItineraryListSheet()
        .environmentObject(viewModel)
}
