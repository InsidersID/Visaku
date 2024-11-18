//
//  VisaTypeSheetView.swift
//  VisaApplicationModule
//
//  Created by Nur Nisrina on 05/11/24.
//

import SwiftUI

struct VisaTypeSheet: View {
    @Binding var isShowVisaTypeSheet: Bool
    @Binding var visaType: String
    
    @EnvironmentObject var viewModel: VisaHistoryViewModel

    let visaTypes = [
        "turis", "pelajar", "bisnis",
    ]
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                ForEach(visaTypes, id: \.self) { type in
                    Button(action: {
                        visaType = type
                        isShowVisaTypeSheet = false
                        viewModel.visaTypeIsEmpty = true
                    }) {
                        Text("Visa \(type)")
                            .font(.custom("Inter-SemiBold", size: 17))
                            .foregroundStyle(Color.blackOpacity5)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding()
                            .bold()
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("Jenis visa")
            .padding(.horizontal)
            .padding(.bottom, 30)
        }
    }
}

#Preview {
    @Previewable @State var isShowVisaTypeSheet = true
    @Previewable @State var visaType = ""

    VisaTypeSheet(isShowVisaTypeSheet: $isShowVisaTypeSheet, visaType: $visaType)
}
