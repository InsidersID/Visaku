//
//  ActionDocumentSheet.swift
//  Visaku
//
//  Created by hendra on 11/11/24.
//

import SwiftUI

struct ActionDocumentSheet: View {
    var documentType: VisaGeneralTouristDocumentType
    @Binding var isMarked: Bool
    @State private var showDocumentDetail = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text(documentType.displayName)
                .font(.headline)
                .padding(24)
                .frame(maxWidth: .infinity, alignment: Alignment(horizontal: .center, vertical: .top))
            
            VStack(alignment: .leading, spacing: 24) {
                if isMarked {
                    HStack {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundStyle(.green)
                        Text("Tandai selesai")
                    }
                    .onTapGesture {
                        isMarked.toggle()
                    }
                } else {
                    HStack {
                        Image(systemName: "x.circle.fill")
                            .foregroundStyle(.red)
                        Text("Tandai belum selesai")
                    }
                    .onTapGesture {
                        isMarked.toggle()
                    }
                }
                
                HStack {
                    Image(systemName: "square.and.arrow.up.circle.fill")
                        .foregroundStyle(.blue)
                    Text("Upload dari device")
                }
                
                HStack {
                    Image(systemName: "camera.circle.fill")
                        .foregroundStyle(.blue)
                    Text("Scan dokumen")
                }
                
                HStack {
                    Image(systemName: "eye.circle.fill")
                        .foregroundStyle(.blue)
                    Text("Lihat ketentuan")
                }
                .onTapGesture {
                    showDocumentDetail = true
                }
            }
            .padding(.bottom, 20)
        }
        .padding()
        .sheet(isPresented: $showDocumentDetail) {
            DocumentDetailSheet(
                title: documentType.displayName, description: documentType.description
            )
            .presentationDetents(.init([.medium]))
            .presentationDragIndicator(.visible)
        }
        Spacer()
    }
}

#Preview {
    @Previewable @State var isMarked: Bool = false
    ActionDocumentSheet(documentType: .asuransiKesehatanPerjalanan, isMarked: $isMarked)
}
