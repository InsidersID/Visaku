//
//  ActionDocumentSheet.swift
//  Visaku
//
//  Created by hendra on 11/11/24.
//

import SwiftUI
import RepositoryModule

struct ActionDocumentSheet: View {
    @Environment(\.dismiss) var dismiss
    
    var documentType: VisaRequirement
    @State private var image: UIImage? = nil
    @State private var fileURL: URL? = nil
    @State private var cameraOpened: Bool = false
    @State private var filePickerPresented: Bool = false
    @State private var showDocumentDetail = false
    @EnvironmentObject var viewModel: CountryVisaApplicationViewModel
    
    @Binding var isMarked: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            // Header
            Text(documentType.displayName)
                .font(.headline)
                .padding(24)
                .frame(maxWidth: .infinity, alignment: .top)
            
            // Conditional content based on requirements
            if !viewModel.showDocumentDetail {
                VStack(alignment: .leading, spacing: 24) {
                    
                    // Toggle Marked Status
                    Button(action: {
                        isMarked.toggle()
                        dismiss()
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
                            Text(isMarked ? "Tandai belum selesai": "Tandai selesai")
                                .font(.custom("Inter-Regular", size: 16))
                                .foregroundStyle(Color.black)
                            
                            Spacer()
                        }
                    }
                    
                    // Conditionally show upload or scan options
                    if documentType.type.uploadType == .file {
                        uploadOption
                    }
                    
                    if documentType.type.uploadType == .image {
                        scanOption
                    }
                    
                    // View document details
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
                    .contentShape(Rectangle())
                    .onTapGesture {
                        viewModel.showDocumentDetail = true
                    }
                }
            } else {
                DocumentDetailSheet(
                    title: documentType.displayName, description: documentType.description
                )
                .environmentObject(viewModel)
            }
        }
        .padding(.top)
        .padding(.horizontal)
        .sheet(isPresented: $filePickerPresented) {
            FilePicker(selectedFileURL: $fileURL)
        }
        .sheet(isPresented: $showDocumentDetail) {
            DocumentDetailSheet(
                title: documentType.displayName, description: documentType.description
            )
            .presentationDetents(.init([.medium]))
            .presentationDragIndicator(.visible)
        }
        .fullScreenCover(isPresented: $cameraOpened) {
            VNDocumentCameraViewControllerRepresentable(scanResult: $image)
        }
        .onChange(of: image) { newValue in
            if let newImage = newValue {
                handleImageUpload(image: newImage)
            }
        }
        .onChange(of: isMarked) { newValue in
            Task {
                await viewModel.updateDocumentMark(for: documentType, to: newValue)
            }
        }
        .onChange(of: fileURL) { newValue in
            if let fileURL = newValue {
                handleFileImport(result: fileURL)
            }
        }
        Spacer()
    }
    
    private var uploadOption: some View {
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
        .onTapGesture {
            filePickerPresented = true
        }
    }
    
    private var scanOption: some View {
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
        .onTapGesture {
            cameraOpened = true
        }
    }
    
    private func handleFileImport(result: URL) {
        fileURL = result
        Task {
            await viewModel.uploadDocument(documentType: documentType, payload: .url(result))
        }
        isMarked.toggle()
    }
    
    private func handleImageUpload(image: UIImage) {
        guard let imageData = image.jpegData(compressionQuality: 0.8) else { return }
        Task {
            await viewModel.uploadDocument(documentType: documentType, payload: .data(imageData))
        }
        isMarked.toggle()
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
