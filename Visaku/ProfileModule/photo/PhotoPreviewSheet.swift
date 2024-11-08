//
//  PhotoPreviewSheet.swift
//  Visaku
//
//  Created by Lonard Steven on 07/11/24.
//

import SwiftUI
import UIComponentModule
import RepositoryModule

public struct PhotoPreviewSheet: View {
    @Environment(\.dismiss) var dismiss
    @State var photoPreviewViewModel: PhotoPreviewViewModel
    @State private var shouldCaptureImage = false
    
    @StateObject private var cameraState = CameraState()
    
    public init(account: AccountEntity) {
        self.photoPreviewViewModel = PhotoPreviewViewModel(account: account)
    }
    
    public var body: some View {
        VStack {
            if let accountImage = photoPreviewViewModel.photoImage {
                Image(uiImage: accountImage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 320, height: 600)
                    .clipShape(RoundedRectangle(cornerRadius: 14))
                    .padding()
            } else {
                RoundedRectangle(cornerRadius: 14)
                    .fill(Color.gray)
                    .frame(width: 300, height: 300)
                    .overlay {
                        VStack {
                            Image(systemName: "photo.badge.exclamationmark")
                                .font(.largeTitle)
                                .foregroundColor(.white)
                            
                            Text("Fotomu sepertinya dalam masalah...")
                                .font(.title)
                                .foregroundColor(.white)
                        }
                    }
            }
            
            Divider()
            
            Text("Diupload \(Date().formatted(date: .abbreviated, time: .omitted))")
                .font(.caption)
                .fontWeight(.bold)
                .padding()
            
            Spacer()
           
            
            // Save and delete buttons
            VStack {
                // Handle the different states of the save operation
                switch photoPreviewViewModel.savePhotoState {
                case .loading:
                    ProgressView("Menyimpan...")
                        .padding()
                case .error:
                    Text("Eror menyimpan gambar akunmu").foregroundColor(.red)
                case .success:
                    Text("Gambar akunmu berhasil disimpan").foregroundColor(.green)
                case .idle:
                    CustomButton(text: "Simpan", color: .blue, fontSize: 17, cornerRadius: 14, paddingHorizontal: 16, paddingVertical: 16) {
                        Task {
                            await photoPreviewViewModel.savePhoto()
                        }
                        dismiss()
                    }
                }

                // Handle the different states of the delete operation
                switch photoPreviewViewModel.deletePhotoState {
                case .loading:
                    ProgressView("Deleting...")
                        .padding()
                case .error:
                    Text("Eror menghapus gambar akunmu").foregroundColor(.red)
                case .success:
                    Text("Gambar akunmu berhasil dihapus").foregroundColor(.green)
                case .idle:
                    CustomButton(text: "Foto ulang", textColor: .primary5, color: .white, fontSize: 17, cornerRadius: 14, paddingHorizontal: 16, paddingVertical: 16) {
                        Task {
                            await photoPreviewViewModel.deletePhoto()
                        }
                        dismiss()
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .fullScreenCover(isPresented: $photoPreviewViewModel.isCameraOpen, content: {
            ZStack {
                CameraViewRepresentable(shouldCaptureImage: $shouldCaptureImage, photoImage: $photoPreviewViewModel.photoImage, cameraState: cameraState)
                    .edgesIgnoringSafeArea(.all)
                    .safeAreaInset(edge: .top) {
                        Color.clear.frame(height: Helper.getStatusBarHeight())
                    }
                
                CameraOverlayView(goToCamera: $photoPreviewViewModel.isCameraOpen, shouldCaptureImage: $shouldCaptureImage, cameraState: cameraState)
                }
        })
        .navigationTitle("Foto")
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

//#Preview {
//    KTPPreviewView()
//}
