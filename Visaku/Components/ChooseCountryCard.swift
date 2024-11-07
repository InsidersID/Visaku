//
//  ChooseCountryCard.swift
//  Servisa
//
//  Created by Nur Nisrina on 23/09/24.
//

import SwiftUI

struct ChooseCountryCard: View {
    let countryName: String
    let imageName: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Image(imageName)
                .padding(5)
            Text(countryName)
                .fontWeight(.semibold)
                .padding(.horizontal, 16)
                .padding(.bottom, 13)
                .font(.system(size: 22))
                .foregroundStyle(.black)
        }
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.white)
        )
    }
}

#Preview {
    ChooseCountryCard(countryName: "Italia", imageName: "italy1")
}
