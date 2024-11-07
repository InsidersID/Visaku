//
//  RedButton.swift
//  Servisa
//
//  Created by Nur Nisrina on 24/09/24.
//

import SwiftUI

struct RedButton: View {
    let text: String
    let isPrimary: Bool
    
    var body: some View {
        Button(action: {
            print(text)
        }) {
            Text(text)
                .font(.title3)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity)
        }
        .padding()
        .background(isPrimary ? Color("redPrimary") : Color("accent"))
        .foregroundColor(.white)
        .cornerRadius(14)
        .padding()
    }
}

#Preview {
    RedButton(text: "Ini button", isPrimary: true)
}
