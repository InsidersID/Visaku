//
//  SwiftUIView.swift
//  VisaApplicationModule
//
//  Created by hendra on 18/10/24.
//

import SwiftUI
import UIComponentModule
import UIKit

struct ItineraryListSheet: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            ScrollView {
                CardContainer(cornerRadius: 24) {
                    
                    VStack(alignment: .leading) {
                        Text("Day 1")
                            .font(.largeTitle)
                            .bold()
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                        Text("Sep 22, 2024")
                            .bold()
                        Text("Pagi")
                        Text("\u{2022} Duomo di Milano")
                        Text("\u{2022} Galleria Vittorio Emanuele II")
                        Text("Siang")
                        Text("\u{2022} Mercato del Duomo")
                        Text("Sore")
                        Text("\u{2022} Teatro alla Scala")
                        Text("Malam")
                        Text("\u{2022} Antica Trattoria della Pesa")
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding()
                }
                
                CardContainer(cornerRadius: 24) {
                    VStack(alignment: .leading) {
                        Text("Day 2")
                            .font(.largeTitle)
                            .bold()
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                        Text("Sep 22, 2024")
                            .bold()
                        Text("Pagi")
                        Text("\u{2022} Duomo di Milano")
                        Text("\u{2022} Galleria Vittorio Emanuele II")
                        Text("Siang")
                        Text("\u{2022} Mercato del Duomo")
                        Text("Sore")
                        Text("\u{2022} Teatro alla Scala")
                        Text("Malam")
                        Text("\u{2022} Antica Trattoria della Pesa")
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding()
                }
                CardContainer(cornerRadius: 24) {
                    VStack(alignment: .leading) {
                        Text("Day 3")
                            .font(.largeTitle)
                            .bold()
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                        Text("Sep 22, 2024")
                            .bold()
                        Text("Pagi")
                        Text("\u{2022} Duomo di Milano")
                        Text("\u{2022} Galleria Vittorio Emanuele II")
                        Text("Siang")
                        Text("\u{2022} Mercato del Duomo")
                        Text("Sore")
                        Text("\u{2022} Teatro alla Scala")
                        Text("Malam")
                        Text("\u{2022} Antica Trattoria della Pesa")
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding()
                }
            }
            .background(LinearGradient(gradient: Gradient(colors: [Color(red: 0.85, green: 0.96, blue: 0.98), Color(red: 0.99, green: 0.99, blue: 0.97)]), startPoint: .top, endPoint: .bottom))
            
            VStack {
                VStack(spacing: 8) {
                    CustomButton(text: "Simpan PDF", color: .blue, font: 17, cornerRadius: 12, paddingHorizontal: 8, paddingVertical: 16) {
                        // Save PDF
                    }
                    
                    CustomButton(text: "Generate Ulang",textColor: .blue, color: .white, font: 17, cornerRadius: 12, paddingHorizontal: 8, paddingVertical: 16) {
                        // Generate Ulang
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
            }
        }
        .navigationTitle("Itinerary")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "x.circle")
                        .font(.title)
                        .foregroundColor(.blue)
                }
            }
        }
    }
}

#Preview {
    ItineraryListSheet()
}
