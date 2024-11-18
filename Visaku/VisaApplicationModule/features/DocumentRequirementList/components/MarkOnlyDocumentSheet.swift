//
//  MarkOnlyDocumentSheet.swift
//  Visaku
//
//  Created by hendra on 11/11/24.
//

import SwiftUI
import RepositoryModule

struct MarkOnlyDocumentSheet: View {
    var documentType: VisaRequirement
    @Binding var isMarked: Bool
    @State private var showDocumentDetail = false
    @EnvironmentObject var viewModel: CountryVisaApplicationViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text(documentType.displayName)
                .font(.headline)
                .padding(24)
                .frame(maxWidth: .infinity, alignment: Alignment(horizontal: .center, vertical: .top))
            
            VStack(alignment: .leading, spacing: 24) {
                Button(action: {
                    isMarked.toggle()
                }) {
                    HStack {
                        Image(systemName: isMarked ? "x.circle.fill": "checkmark.circle.fill")
                            .foregroundStyle(isMarked ? .red : .green)
                            .font(.custom("Inter-Regular", size: 16))
                        
                        Text(isMarked ? "Tandai belum selesai" : "Tandai selesai")
                            .font(.custom("Inter-Regular", size: 16))
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
                            .font(.custom("Inter-Regular", size: 16))
                        Text("Lihat ketentuan")
                            .foregroundStyle(.black)
                            .font(.custom("Inter-Regular", size: 16))
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
        .onChange(of: isMarked) { newValue in
            Task {
                await viewModel.updateDocumentMark(for: documentType, to: newValue)
            }
        }
        Spacer()
    }
}

#Preview {
    @Previewable @State var isMarked: Bool = false
    let mockViewModel = CountryVisaApplicationViewModel()

    ActionDocumentSheet(
        documentType: VisaRequirement(type: .buktiKeuangan, displayName: "Tes", description: "Tes", requiresUpload: true, isOptionalUpload: true),
        isMarked: $isMarked
    )
    .environmentObject(mockViewModel)
}
