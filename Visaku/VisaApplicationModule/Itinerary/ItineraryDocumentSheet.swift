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
    @State private var showItineraryPolicySheet = false

    var handlePickedPDF: (URL) -> Void
    @State var isShowItineraryAccommodationSheet: Bool = false
    
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
                CustomButton(text: "Generate dengan AI", color: Color.primary5, font: "Inter-Regular", fontSize: 16, cornerRadius: 14, paddingHorizontal: 16, paddingVertical: 16) {
                    isShowItineraryAccommodationSheet = true
                }
                CustomButton(text: "Upload dari device", color: Color.primary5, font: "Inter-Regular", fontSize: 16, cornerRadius: 14, paddingHorizontal: 16, paddingVertical: 16) {
                    //Upload Document
                }
                CustomButton(text: "Scan Dokumen", color: Color.primary5, font: "Inter-Regular", fontSize: 16, cornerRadius: 14, paddingHorizontal: 16, paddingVertical: 16) {
                    // Scanning Document
                }
                CustomButton(text: "Lihat ketentuan", color: Color.primary5, font: "Inter-Regular", fontSize: 16, cornerRadius: 14, paddingHorizontal: 16, paddingVertical: 16) {
                    showItineraryPolicySheet = true
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
                        .foregroundColor(Color.primary5)
                }
            }
        }
        .sheet(isPresented: $isShowItineraryAccommodationSheet) {
            ItineraryAccommodationSheet()
        }
        .sheet(isPresented: $showItineraryPolicySheet) {
            ItineraryPolicySheet()
                .presentationDetents([.height(520)])
                .presentationDragIndicator(.visible)
        }
    }
}

#Preview {
    ItineraryDocumentSheet { url in
        print(url)
    }
}

