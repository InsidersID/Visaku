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
    @StateObject var photoPreviewViewModel: PhotoPreviewViewModel
    @State private var shouldCaptureImage = false
    
    @StateObject private var cameraState = CameraState()
    
    var origin: PhotoPreviewOrigin
    
    public init(account: AccountEntity, photoImage: UIImage? = nil, origin: PhotoPreviewOrigin) {
        self.origin = origin
        self._photoPreviewViewModel = StateObject(wrappedValue: PhotoPreviewViewModel(account: account))
        self.photoPreviewViewModel.photoImage = photoImage
        
        if self.origin == .imagePicker {
            photoPreviewViewModel.isCameraOpen = false
        }
    }
    
    public var body: some View {
        NavigationStack {
            ScrollView(.vertical, showsIndicators: true) {
                VStack {
                    Spacer()
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
                                        .font(.title2)
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
                            Text("Gambar akunmu berhasil disimpan")
                                .foregroundColor(.green)
                                .task {
                                await photoPreviewViewModel.handleSuccess()
                            }
                        case .idle:
                            CustomButton(text: "Simpan", color: Color.primary5, fontSize: 17, cornerRadius: 14, paddingHorizontal: 16, paddingVertical: 16) {
                                Task {
                                    await photoPreviewViewModel.savePhoto()
                                    await ProfileViewModel.shared.fetchAccountByID(photoPreviewViewModel.account.id)
                                }
                                dismiss()
                            }
                        }

                        switch photoPreviewViewModel.deletePhotoState {
                        case .loading:
                            ProgressView("Menghapus...")
                                .padding()
                        case .error:
                            Text("Eror menghapus gambar akunmu").foregroundColor(.red)
                        case .success:
                            Text("Gambar akunmu berhasil dihapus").foregroundColor(.green)
                        case .idle:
                            CustomButton(text: "Foto ulang", textColor: .primary5, color: .white, fontSize: 17, cornerRadius: 14, paddingHorizontal: 16, paddingVertical: 16) {
                                Task {
                                    await photoPreviewViewModel.deletePhoto()
                                    DispatchQueue.main.async {
                                         photoPreviewViewModel.photoImage = nil
                                         photoPreviewViewModel.isCameraOpen = true
                                         photoPreviewViewModel.deletePhotoState = .idle
                                     }
                                }
                            }
                        }
                    }
                }
                .padding(.bottom, 16)
                .frame(maxWidth: .infinity)
            }
            .onChange(of: photoPreviewViewModel.photoImage) { newValue in
                print("Photo image has been updated: \(String(describing: newValue))")
            }
            .onDisappear {
                NotificationCenter.default.post(name: .accountImageUpdated, object: photoPreviewViewModel.account.id)
            }
            .navigationTitle("Foto")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarRole(.navigationStack)
            .navigationBarItems(trailing: Button(action: {
                dismiss()
            }) {
                Image(systemName: "x.circle")
                    .font(.title)
                    .foregroundColor(Color.primary5)
            })
            .fullScreenCover(isPresented: $photoPreviewViewModel.isCameraOpen, content: {
                ZStack {
                    CameraViewRepresentable(photoImage: $photoPreviewViewModel.photoImage, cameraState: cameraState, onDismiss: { dismiss() })
                        .edgesIgnoringSafeArea(.all)
                        .safeAreaInset(edge: .top) {
                            Color.clear.frame(height: Helper.getStatusBarHeight())
                        }
                    
                    CameraOverlayView(goToCamera: $photoPreviewViewModel.isCameraOpen, cameraState: cameraState)
                }
            })
        }
        
        
    }
}

//#Preview {
//    KTPPreviewView()
//}
