//
//  ApplyVisaCard.swift
//  VisaApplicationModule
//
//  Created by Nur Nisrina on 25/10/24.
//

import SwiftUI
import UIComponentModule

struct ApplyVisaCard: View {
    var body: some View {
        CardContainer(cornerRadius: 25) {
            VStack {
                VStack {
                    HStack{
                        Image(systemName: "person.fill")
                            .font(.system(size: 26))
                            .foregroundStyle(.blue)
                        Spacer()
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Mau traveling ke mana?")
                                .font(.system(size: 22))
                                .bold()
                            Text("Yuk, ajukan visamu sekarang.")
                                .font(.system(size: 17))
                                .foregroundStyle(.gray)
                        }
                    }
                    .padding(.bottom, 24)
                    .padding(.horizontal)
                }
                VStack {
                    CustomButton(text: "Mulai pengajuan", color: .blue, font: 18, cornerRadius: 10, paddingHorizontal: 80, paddingVertical: 18) {
                        
                    }
                }
            }
            .padding()
        }
    }
}

#Preview {
    ApplyVisaCard()
}
