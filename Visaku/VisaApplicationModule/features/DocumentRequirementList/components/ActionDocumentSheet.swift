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
    @State private var image: UIImage? = nil
    @State private var fileURL: URL? = nil
    @State private var cameraOpened: Bool = false
    @State private var filePickerPresented: Bool = false
    @State private var showDocumentDetail = false
    @EnvironmentObject var viewModel: CountryVisaApplicationViewModel
    
    @Binding var isMarked: Bool
    
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
                        
                        Text(isMarked ? "Tandai belum selesai": "Tandai selesai")
                            .font(.custom("Inter-Regular", size: 16))
                            .foregroundStyle(.black)
                    }
                    .contentShape(Rectangle())
                }
                
                HStack {
                    Image(systemName: "square.and.arrow.up.circle.fill")
                        .foregroundStyle(.blue)
                        .font(.custom("Inter-Regular", size: 16))
                    Text("Upload dari device")
                        .font(.custom("Inter-Regular", size: 16))
                }
                
                HStack {
                    Image(systemName: "camera.circle.fill")
                        .foregroundStyle(.blue)
                        .font(.custom("Inter-Regular", size: 16))
                    Text("Scan dokumen")
                        .font(.custom("Inter-Regular", size: 16))
                }.onTapGesture {
                    cameraOpened.toggle()
                }
                
                HStack {
                    Image(systemName: "eye.circle.fill")
                        .foregroundStyle(.blue)
                        .font(.custom("Inter-Regular", size: 16))
                    Text("Lihat ketentuan")
                        .foregroundStyle(.black)
                        .font(.custom("Inter-Regular", size: 16))
                }
                .onTapGesture {
                    showDocumentDetail = true
                }
            }
            .padding(.bottom, 20)
        }
        .padding()
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
    
    private func handleFileImport(result: URL) {
        fileURL = result
        Task {
            await viewModel.uploadDocument(documentType: documentType, payload: .url(result))
        }
        isMarked.toggle()
    }
    
    // Handle image upload
    private func handleImageUpload(image: UIImage) {
        guard let imageData = image.jpegData(compressionQuality: 0.8) else { return }
        Task {
            await viewModel.uploadDocument(documentType: documentType, payload: .data(imageData))
        }
        isMarked.toggle()
    }
}

//#Preview {
//    @Previewable @State var isMarked: Bool = false
//    let mockViewModel = CountryVisaApplicationViewModel()
//
//    ActionDocumentSheet(
//        documentType: .asuransiKesehatanPerjalanan,
//        isMarked: $isMarked
//    )
//    .environmentObject(mockViewModel)
//}
