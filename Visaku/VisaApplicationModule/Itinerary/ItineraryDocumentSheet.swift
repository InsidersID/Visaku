//
//  SwiftUIView.swift
//  VisaApplicationModule
//
//  Created by hendra on 18/10/24.
//

import SwiftUI
import UIComponentModule

struct ItineraryDocumentSheet: View {
    @Environment(\.dismiss) var dismiss
    @State private var showFileImporter = false
    var handlePickedPDF: (URL) -> Void
    
    var body: some View {
        VStack {
            VStack {
                Button {
                    showFileImporter = true
                } label: {
                    VStack {
                        Image(systemName: "doc.fill")
                            .padding()
                            .background(
                                Circle()
                                    .stroke(style: StrokeStyle(lineWidth: 1))
                                    .foregroundStyle(.gray)
                            )
                        Text("Klik untuk upload PDF")
                            .font(.headline)
                        Text("(Max. file size: 25 MB)")
                            .foregroundStyle(.gray)
                    }
                }
                .fileImporter(isPresented: $showFileImporter, allowedContentTypes: [.pdf]) { result in
                    switch result {
                    case .success(let url):
                        handlePickedPDF(url)
                    case .failure(let error):
                        print(error)
                    }
                }
            }
            .frame(width: 300, height: 566)
            .padding()
            .background(
                Rectangle()
                    .stroke(style: StrokeStyle(lineWidth: 1, dash: [6, 6]))
                    .foregroundStyle(.gray)
            )
            
            VStack(spacing: 8) {
                CustomButton(text: "Scan Dokumen", color: .blue, font: 17, cornerRadius: 14, paddingHorizontal: 16, paddingVertical: 16) {
                    // Scanning Document
                }
                CustomButton(text: "Upload", textColor: .blue, color: .white, font: 17, cornerRadius: 14, paddingHorizontal: 16, paddingVertical: 16) {
                    //Upload Document
                }
            }
            .padding()
        }
        .navigationTitle("Itinerary")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "x.circle")
                        .font(.title)
                        .foregroundColor(.blue)
                }
            }
        }
    }
}

#Preview {
    ItineraryDocumentSheet { url in
        print(url)
    }
}
