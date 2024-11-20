//
//  SwiftUIView.swift
//  VisaApplicationModule
//
//  Created by hendra on 18/10/24.
//
import SwiftUI
import UIComponentModule

struct ItineraryListSheet: View {
    @Environment(\.dismiss) var dismiss
    let itinerary: Itinerary
    @State var displayButtonsOnSheet = true
    var onDismiss: () -> Void

    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    ScrollView {
                        VStack {
                            ForEach(Array(itinerary.days.enumerated()), id: \.element.day) { index, day in
                                CardContainer(cornerRadius: 24) {
                                    VStack(alignment: .leading) {
                                        HStack {
                                            Text("\(day.day)")
                                                .font(.largeTitle)
                                                .bold()
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                            Spacer()
                                            Image(systemName: "pencil")
                                                .font(.system(size: 20))
                                            
                                        }
                                        Text("\(day.date)")
                                            .bold()
                                            .padding(.bottom, 5)
                                        Text("Morning")
                                        ForEach(day.activities.morning, id: \.self) { activity in
                                            Text("• \(activity)")
                                        }
                                        Text("Afternoon")
                                        ForEach(day.activities.afternoon, id: \.self) { activity in
                                            Text("• \(activity)")
                                        }
                                        Text("Evening")
                                        ForEach(day.activities.evening, id: \.self) { activity in
                                            Text("• \(activity)")
                                        }
                                    }
                                }
                            }
                        }
                        Spacer()
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 150)
                }
                VStack {
                    Spacer()
                    VStack(spacing: 5) {
                        CustomButton(text: "Simpan", color: .blue, fontSize: 17, cornerRadius: 12, paddingHorizontal: 8, paddingVertical: 16) {
                        }
                        CustomButton(text: "Generate ulang", textColor: .blue, color: .white, fontSize: 17, cornerRadius: 12, paddingHorizontal: 8, paddingVertical: 16) {
                        }
                        .padding(.bottom, 15)
                    }
                    .padding()
                    .background(.white)
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
}




#Preview {
    @Previewable @State var itinerary = Itinerary(days: [
        Day(
            day: "Monday",
            date: "2024-11-18",
            activities: Activities(
                morning: ["Visit museum", "Have breakfast at café"],
                afternoon: ["Lunch at Italian restaurant", "Go hiking in the nearby trails"],
                evening: ["Dinner at rooftop restaurant", "Watch a movie"]
            )
        ),
        Day(
            day: "Tuesday",
            date: "2024-11-19",
            activities: Activities(
                morning: ["Morning yoga session", "Visit local market"],
                afternoon: ["Picnic in the park", "Attend art gallery exhibition"],
                evening: ["Fine dining experience", "Stargazing event"]
            )
        ),
        Day(
            day: "Wednesday",
            date: "2024-11-19",
            activities: Activities(
                morning: ["Morning yoga session", "Visit local market"],
                afternoon: ["Picnic in the park", "Attend art gallery exhibition"],
                evening: ["Fine dining experience", "Stargazing event"]
            )
        )
    ])

    ItineraryListSheet(itinerary: itinerary, onDismiss: {})
}
