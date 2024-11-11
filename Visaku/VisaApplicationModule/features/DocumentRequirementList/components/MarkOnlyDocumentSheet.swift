//
//  MarkOnlyDocumentSheet.swift
//  Visaku
//
//  Created by hendra on 11/11/24.
//

import SwiftUI

struct MarkOnlyDocumentSheet: View {
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
                            .font(.system(size: 16))
                        Text("Tandai selesai")
                            .font(.system(size: 16))
                    }
                    .onTapGesture {
                        isMarked.toggle()
                    }
                } else {
                    HStack {
                        Image(systemName: "x.circle.fill")
                            .foregroundStyle(.red)
                            .font(.system(size: 16))
                        Text("Tandai belum selesai")
                            .font(.system(size: 16))
                    }
                    .onTapGesture {
                        isMarked.toggle()
                    }
                }
                
                HStack {
                    Image(systemName: "eye.circle.fill")
                        .foregroundStyle(.blue)
                        .font(.system(size: 16))
                    Text("Lihat ketentuan")
                        .font(.system(size: 16))
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
    MarkOnlyDocumentSheet(documentType: .asuransiKesehatanPerjalanan, isMarked: $isMarked)
}
