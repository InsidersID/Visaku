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
                        ZStack {
                            Circle()
                                .frame(width: 22)
                                .foregroundStyle(isMarked ? Color.danger5 : Color.success6)
                            
                            Image(systemName: isMarked ? "xmark": "checkmark")
                                .imageScale(.small)
                                .foregroundStyle(Color.white)
                                .fontWeight(.bold)
                        }
                        
                        Text(isMarked ? "Tandai belum selesai" : "Tandai selesai")
                            .font(.custom("Inter-Regular", size: 16))
                            .foregroundStyle(Color.black)
                    }
                    .contentShape(Rectangle())
                }
                
                Button(action: {
                    showDocumentDetail = true
                }) {
                    HStack {
                        ZStack {
                            Circle()
                                .frame(width: 22)
                                .foregroundStyle(Color.primary5)
                            
                            Image(systemName: "eye")
                                .resizable()
                                .frame(width: 14, height: 11)
                                .foregroundStyle(Color.white)
                                .fontWeight(.bold)
                        }
                        
                        Text("Lihat ketentuan")
                            .foregroundStyle(Color.black)
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
        documentType: VisaRequirement(type: .buktiKeuangan, displayName: "Tes", description: "Tes", requiresUpload: false, isOptionalUpload: false),
        isMarked: $isMarked
    )
    .environmentObject(mockViewModel)
}
