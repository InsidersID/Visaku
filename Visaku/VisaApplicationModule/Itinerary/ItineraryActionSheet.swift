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
    @State private var isShowItineraryPolicySheet = false

    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 8) {
                Group {
                    HStack {
                        ZStack {
                            Circle()
                                .frame(width: 22)
                                .foregroundStyle(Color.primary5)
                            Image(systemName: "wand.and.stars.inverse")
                                .font(.system(size: 14.5))
                                .imageScale(.small)
                                .foregroundStyle(Color.white)
                                .fontWeight(.semibold)
                        }
                        Text("Buat dokumen dengan AI")
                            .font(.custom("Inter-Regular", size: 16))
                            .foregroundStyle(Color.black)
                        
                        Spacer()
                    }
                    .onTapGesture {
                        aiItineraryGenerator.toggle()
                    }
                    HStack {
                        ZStack {
                            Circle()
                                .frame(width: 22)
                                .foregroundStyle(Color.primary5)
                            Image(systemName: "square.and.arrow.up")
                                .font(.system(size: 14.5))
                                .imageScale(.small)
                                .foregroundStyle(Color.white)
                                .fontWeight(.semibold)
                        }
                        Text("Upload dari device")
                            .font(.custom("Inter-Regular", size: 16))
                            .foregroundStyle(Color.black)
                        
                        Spacer()
                    }
                    .onTapGesture {
                    }
                    HStack {
                        ZStack {
                            Circle()
                                .frame(width: 22)
                                .foregroundStyle(Color.primary5)
                            Image(systemName: "camera")
                                .font(.system(size: 14.5))
                                .imageScale(.small)
                                .foregroundStyle(Color.white)
                                .fontWeight(.semibold)
                        }
                        Text("Scan dokumen")
                            .font(.custom("Inter-Regular", size: 16))
                            .foregroundStyle(Color.black)
                        
                        Spacer()
                    }
                    .onTapGesture {
                    }
                    HStack {
                        ZStack {
                            Circle()
                                .frame(width: 22)
                                .foregroundStyle(Color.primary5)
                            Image(systemName: "eye")
                                .font(.system(size: 14.5))
                                .imageScale(.small)
                                .foregroundStyle(Color.white)
                                .fontWeight(.semibold)
                        }
                        Text("Lihat ketentuan")
                            .font(.custom("Inter-Regular", size: 16))
                            .foregroundStyle(Color.black)
                        
                        Spacer()
                    }
                    .onTapGesture {
                        isShowItineraryPolicySheet = true
                    }
                }
                .padding(12)
                Spacer()
            }
            .padding(.horizontal, 20)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Itinerary")
                        .font(.custom("Inter-SemiBold", size: 16))

                }
            }
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
            .sheet(isPresented: $isShowItineraryPolicySheet) {
                ItineraryPolicySheet()
                    .presentationDetents([.height(520)])
                    .presentationDragIndicator(.visible)
            }
        }
    }
}

#Preview {
    ItineraryActionSheet()
}
