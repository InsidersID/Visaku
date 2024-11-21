//
//  ItineraryListSheet.swift
//  VisaApplicationModule
//
//  Created by hendra on 18/10/24.
//

import SwiftUI
import UIComponentModule

struct ItineraryListSheet: View {
    @Environment(\.dismiss) var dismiss
    @State private var itinerary: Itinerary = Itinerary(days: [])
        
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    ScrollView {
                        VStack {
                            if itinerary.days.isEmpty {
                                Text("Loading itinerary...")
                                    .onAppear {
                                        loadItinerary()
                                    }
                            } else {
                                ForEach(itinerary.days) { day in
                                    ItineraryCard(day: day)
                                }
                            }
                        }
                        Spacer()
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 150)
                }
                VStack {
                    ButtonsView()
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
        }
    }
    
    func loadItinerary() {
        let json = """
            {
                "days": [
                    {
                        "title": "Day 1",
                        "date": "2024-11-18",
                        "morning": {
                            "placeName": "Central Park",
                            "placeLatitude": 40.785091,
                            "placeLongitude": -73.968285,
                            "activity": "Morning jog and sightseeing"
                        },
                        "afternoon": {
                            "placeName": "Metropolitan Museum of Art",
                            "placeLatitude": 40.779437,
                            "placeLongitude": -73.963244,
                            "activity": "Explore the museum exhibits"
                        },
                        "night": {
                            "placeName": "Top of the Rock",
                            "placeLatitude": 40.759080,
                            "placeLongitude": -73.978540,
                            "activity": "Enjoy the city skyline views"
                        }
                    },
                    {
                        "title": "Day 2",
                        "date": "2024-11-19",
                        "morning": {
                            "placeName": "Brooklyn Bridge",
                            "placeLatitude": 40.706086,
                            "placeLongitude": -73.996864,
                            "activity": "Walk across the iconic bridge"
                        },
                        "afternoon": {
                            "placeName": "DUMBO",
                            "placeLatitude": 40.703316,
                            "placeLongitude": -73.988145,
                            "activity": "Lunch and shopping at DUMBO"
                        },
                        "night": {
                            "placeName": "Broadway Theatre",
                            "placeLatitude": 40.759011,
                            "placeLongitude": -73.984472,
                            "activity": "Watch a Broadway show"
                        }
                    },
                    {
                        "title": "Day 3",
                        "date": "2024-11-19",
                        "morning": {
                            "placeName": "Brooklyn Bridge",
                            "placeLatitude": 40.706086,
                            "placeLongitude": -73.996864,
                            "activity": "Walk across the iconic bridge"
                        },
                        "afternoon": {
                            "placeName": "DUMBO",
                            "placeLatitude": 40.703316,
                            "placeLongitude": -73.988145,
                            "activity": "Lunch and shopping at DUMBO"
                        },
                        "night": {
                            "placeName": "Broadway Theatre",
                            "placeLatitude": 40.759011,
                            "placeLongitude": -73.984472,
                            "activity": "Watch a Broadway show"
                        }
                    }
                ]
            }
            """
        
        if let jsonData = json.data(using: .utf8) {
            do {
                let decodedItinerary = try JSONDecoder().decode(Itinerary.self, from: jsonData)
                itinerary = decodedItinerary
            } catch {
                print("Error decoding JSON: \(error)")
            }
        }
    }
}


struct ButtonsView: View {
    
    var body: some View {
        VStack {
            Spacer()
            VStack {
                CustomButton(text: "Simpan", color: .blue, font: "Inter-SemiBold", fontSize: 17, cornerRadius: 12, paddingHorizontal: 8, paddingVertical: 16) {
                }
                .font(.custom("Inter-SemiBold", size: 20))

                CustomButton(text: "Generate ulang", textColor: .blue, color: .white, font: "Inter-SemiBold", fontSize: 17, cornerRadius: 12, paddingHorizontal: 8, paddingVertical: 16) {
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
    ItineraryListSheet()
}
