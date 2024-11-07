//
//  VisaTypeSheetView.swift
//  VisaApplicationModule
//
//  Created by Nur Nisrina on 05/11/24.
//

import SwiftUI

struct VisaTypeSheetView: View {
    @Binding var isShowVisaTypeSheet: Bool
    @Binding var visaType: String

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
                    }) {
                        Text("Visa \(type)")
                            .font(.system(size: 17))
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

    VisaTypeSheetView(isShowVisaTypeSheet: $isShowVisaTypeSheet, visaType: $visaType)
}
