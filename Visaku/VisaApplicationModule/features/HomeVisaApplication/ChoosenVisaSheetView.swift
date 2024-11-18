//
//  ChoosenVisaSheetView.swift
//  VisaApplicationModule
//
//  Created by Nur Nisrina on 07/11/24.
//

import SwiftUI

struct ChoosenVisaSheetView: View {
    @Binding var choosenCountry: String
    @Binding var choosenVisaType: String

    var body: some View {
        VStack {
            VStack(spacing: 8) {
                Text("Visa yang kamu akan ajukan adalah")
                    .font(.custom("Inter-Regular", size: 14))
                    .foregroundStyle(Color.blackOpacity3)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text("Visa \(choosenVisaType) \(choosenCountry)")
                    .font(.custom("Inter-SemiBold", size: 20))
                    .foregroundStyle(Color.blackOpacity5)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding()
            
        }
        .padding()
       
        
    }
}

#Preview {
    @Previewable @State var choosenCountry = "Italia"
    @Previewable @State var choosenVisaType = "turis"

    ChoosenVisaSheetView(choosenCountry: $choosenCountry, choosenVisaType: $choosenVisaType)
}
