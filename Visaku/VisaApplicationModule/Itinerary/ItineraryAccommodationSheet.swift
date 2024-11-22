//
//  ItineraryAccommodationSheet.swift
//  attemp1
//
//  Created by Nur Nisrina on 19/11/24.
//

import SwiftUI
import UIComponentModule

struct ItineraryAccommodationSheet: View {
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    Text("Daftar tempat tinggal")
                        .bold()
                        .font(.system(size: 16))
                        .frame(maxWidth: .infinity, alignment: .leading)
                    CardContainer(cornerRadius: 24) {
                        VStack(spacing: 12) {
                            HStack {
                                Text("Italia🇮🇹")
                                    .bold()
                                    .font(.system(size: 20))
                                Spacer()
                                Text("\(Date.now.formatted(date: .complete, time: .omitted))")
                                    .font(.system(size: 16))
                            }
                            VStack {
                                VStack {
                                    HStack {
                                        VStack(spacing: 7) {
                                            Text("Tempat tinggal 1")
                                                .bold()
                                                .font(.system(size: 16))
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                            Text("Via della Scafa, 416, 00054 Fiumicino RM, Italy")
                                                .foregroundStyle(.secondary)
                                                .font(.system(size: 11))
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                        }
                                        
                                        Image(systemName: "line.3.horizontal")
                                            .foregroundStyle(Color.gray)
                                    }
                                    .padding(.all, 24)
                                    Divider()
                                }
                                VStack {
                                    HStack {
                                        Text("Masukkan tempat tinggal")
                                            .foregroundStyle(.secondary)
                                            .font(.system(size: 16))
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                        Image(systemName: "plus.circle")
                                            .foregroundStyle(Color.gray)
                                    }
                                    .padding(.all, 24)
                                    Divider()
                                }
                            }
                            
                        }
                    }
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.bottom, 150)
                VStack {
                    Spacer()
                    VStack(spacing: 5) {
                        CustomButton(text: "Buat Itinerary", color: Color.primary5, fontSize: 17, cornerRadius: 12, paddingHorizontal: 8, paddingVertical: 16) {
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 30)
                    }
                    .padding()
                    .background(.white)
                }
                .ignoresSafeArea(.all)
            }
            .navigationBarBackButtonHidden()
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("AI Itinerary Generator")
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
    ItineraryAccommodationSheet()
}
