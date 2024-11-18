//
//  ActionDocumentSheet.swift
//  Visaku
//
//  Created by hendra on 11/11/24.
//

import SwiftUI
import RepositoryModule

struct ActionDocumentSheet: View {
    var documentType: VisaRequirement
    @EnvironmentObject var viewModel: CountryVisaApplicationViewModel
    
    @Binding var isMarked: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text(documentType.displayName)
                .font(.headline)
                .padding(24)
                .frame(maxWidth: .infinity, alignment: Alignment(horizontal: .center, vertical: .top))
            
            if !viewModel.showDocumentDetail {
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
                                //                                .offset(x: 0, y: -1)
                            }
                            
                            Text(isMarked ? "Tandai belum selesai": "Tandai selesai")
                                .font(.custom("Inter-Regular", size: 16))
                                .foregroundStyle(Color.black)
                            
                            Spacer()
                        }
                        .contentShape(Rectangle())
                    }
                    
                    HStack {
                        ZStack {
                            Circle()
                                .frame(width: 22)
                                .foregroundStyle(Color.primary5)
                            
                            Image(systemName: "square.and.arrow.up")
                                .resizable()
                                .frame(width: 11, height: 13)
                                .foregroundStyle(Color.white)
                                .fontWeight(.bold)
                                .offset(x: 0, y: -1)
                        }
                        
                        Text("Upload dari device")
                            .font(.custom("Inter-Regular", size: 16))
                        
                        Spacer()
                    }
                    
                    HStack {
                        ZStack {
                            Circle()
                                .frame(width: 22)
                                .foregroundStyle(Color.primary5)
                            
                            Image(systemName: "camera")
                                .resizable()
                                .frame(width: 14, height: 12)
                                .foregroundStyle(Color.white)
                                .fontWeight(.bold)
                                .offset(x: 0, y: -1)
                        }
                        
                        Text("Scan dokumen")
                            .font(.custom("Inter-Regular", size: 16))
                        
                        Spacer()
                    }
                    
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
                            .foregroundStyle(Color.blackOpacity5)
                            .font(.custom("Inter-Regular", size: 16))
                        
                        Spacer()
                    }
                    .onTapGesture {
                        viewModel.showDocumentDetail = true
                    }
                }
                .padding(.bottom, 20)
            } else {
                DocumentDetailSheet(
                    title: documentType.displayName, description: documentType.description
                )
                .environmentObject(viewModel)
            }
        }
        .padding()
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
        documentType: .init(type: .asuransiKesehatanPerjalanan, displayName: "nama", description: "deskripsi", requiresUpload: false, isOptionalUpload: false),
        isMarked: $isMarked
    )
    .environmentObject(mockViewModel)
}
