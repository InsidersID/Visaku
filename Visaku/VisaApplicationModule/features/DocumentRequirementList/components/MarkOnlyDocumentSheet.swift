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
    @ObservedObject var viewModel: CountryVisaApplicationViewModel
    @State private var showDocumentDetail = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text(documentType.displayName)
                .font(.headline)
                .padding(24)
                .frame(maxWidth: .infinity, alignment: Alignment(horizontal: .center, vertical: .top))
            
            VStack(alignment: .leading, spacing: 24) {
                Button(action: {
                    isMarked.toggle()
                    viewModel.isMarkedStatus[documentType] = isMarked
                    print("isMarked toggled: \(isMarked)")
                    print("isMarkedStatus in ViewModel: \(viewModel.isMarkedStatus[documentType] ?? false)")
                }) {
                    HStack {
                        Image(systemName: isMarked ? "x.circle.fill": "checkmark.circle.fill")
                            .foregroundStyle(isMarked ? .red : .green)
                            .font(.system(size: 24))
                        
                        Text(isMarked ? "Tandai belum selesai" : "Tandai selesai")
                            .font(.system(size: 24))
                            .foregroundStyle(.black)
                    }
                    .contentShape(Rectangle())
                }
                
                Button(action: {
                    showDocumentDetail = true
                }) {
                    HStack {
                        Image(systemName: "eye.circle.fill")
                            .foregroundStyle(.blue)
                            .font(.system(size: 24))
                        Text("Lihat ketentuan")
                            .font(.system(size: 24))
                    }
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
    let mockViewModel = CountryVisaApplicationViewModel(
            isMarkedStatus: [
                .asuransiKesehatanPerjalanan: false,
                .fotokopiPaspor: true
            ]
        )

    ActionDocumentSheet(
        documentType: .asuransiKesehatanPerjalanan,
        isMarked: $isMarked,
        viewModel: mockViewModel
    )
}
