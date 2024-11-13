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
                            .foregroundStyle(.black)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding()
                            .bold()
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Jenis visa")
                        .font(.headline)
                }
            }
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
