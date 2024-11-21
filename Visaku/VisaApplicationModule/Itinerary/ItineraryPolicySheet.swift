//
//  ItineraryPolicySheet.swift
//  Visaku
//
//  Created by Nur Nisrina on 21/11/24.
//

import SwiftUI
import UIComponentModule

struct ItineraryPolicySheet: View {
    
    @State var state: Int = 1
    let policies = ["Dengan itinerary, kedutaan jadi tahu kamu punya tujuan jelas dan nggak berencana tinggal lebih lama dari yang diizinkan.", "Melalui Visaku, kamu bisa upload dokumen, scan dokumen, atau membuat dokumen itinerary dengan AI!"]

    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                Image("itineraryMap")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 345, height: 247)
                Text("\(state == 1 ? policies[0] : policies[1])")
                    .frame(width: 345)
                    .font(.custom("Inter-Regular", size: 16))
                    .foregroundStyle(Color.blackOpacity3)
                    .padding(.horizontal)
                    .multilineTextAlignment(.center)
                CustomButton(text: state == 1 ? "Selanjutnya" : "OK", color: state == 1 ? Color(.primary4) : Color(.primary5), font: "Inter-SemiBold", fontSize: 17) {
                    state = 2
                }
            }
            .padding(.vertical)
            .padding(.horizontal, 24)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Itinerary")
                        .font(.custom("Inter-SemiBold", size: 16))
                    
                }
            }
        }
    }
}

#Preview {
    ItineraryPolicySheet()
}
