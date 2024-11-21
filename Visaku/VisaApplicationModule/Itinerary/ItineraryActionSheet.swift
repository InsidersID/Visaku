//
//  ItineraryActionList.swift
//  Visaku
//
//  Created by hendra on 21/11/24.
//

import Foundation
import SwiftUI

struct ItineraryActionSheet: View {
    @Environment(\.dismiss) var dismiss
    @State var aiItineraryGenerator: Bool = false
    @EnvironmentObject var viewModel: CountryVisaApplicationViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Itinerary")
                .frame(maxWidth: .infinity, alignment: Alignment(horizontal: .center, vertical: .center))
                .padding()
            Group {
                HStack {
                    Image(systemName: "wand.and.stars.inverse")
                        .padding(8)
                        .background(Color.primary5)
                        .foregroundColor(.white)
                        .clipShape(Circle())
                    Text("Buat dokumen dengan AI")
                }
                .onTapGesture {
                    aiItineraryGenerator.toggle()
                }
                HStack {
                    Image(systemName: "square.and.arrow.up")
                        .padding(8)
                        .background(Color.primary5)
                        .foregroundColor(.white)
                        .clipShape(Circle())
                    Text("Upload dari device")
                }
                HStack {
                    Image(systemName: "camera")
                        .padding(8)
                        .background(Color.primary5)
                        .foregroundColor(.white)
                        .clipShape(Circle())
                    Text("Scan dokumen")
                }
                HStack {
                    Image(systemName: "eye")
                        .padding(8)
                        .background(Color.primary5)
                        .foregroundColor(.white)
                        .clipShape(Circle())
                    Text("Lihat ketentuan")
                }
            }
            .padding(12)
            Spacer()
        }
        .padding(.horizontal, 20)
        .sheet(isPresented: $aiItineraryGenerator) {
            if let trip = viewModel.trip {
                AiItineraryGeneratorSheet(countries: Binding(get: {
                    trip.countries
                }, set: { newCountries in
                    viewModel.trip?.countries = newCountries
                }))
                .environmentObject(viewModel)
                .presentationDragIndicator(.visible)
            } else {
                Text("No trip data available.")
                    .presentationDragIndicator(.visible)
            }
        }
    }
}

#Preview {
    ItineraryActionSheet()
}
