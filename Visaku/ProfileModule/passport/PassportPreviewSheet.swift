//
//  PassportPreviewSheet.swift
//  ProfileModule
//
//  Created by hendra on 20/10/24.
//

import SwiftUI
import UIComponentModule
import RepositoryModule

public struct PassportPreviewSheet: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var passportPreviewViewModel: PassportPreviewViewModel
    
    var origin: PassportPreviewOrigin
    @State private var passportImage: UIImage?
    
    public init(account: AccountEntity, selectedImage: UIImage? = nil, origin: PassportPreviewOrigin) {
        self.passportPreviewViewModel = PassportPreviewViewModel(account: account)
        self.origin = origin
        
        if let unwrappedImage = selectedImage {
            self.passportPreviewViewModel.passportImage = unwrappedImage
            self.passportPreviewViewModel.processCapturedImage(unwrappedImage)
         } else {
             print("No image to process from ImagePicker, waiting for camera scan.")
         }
    }
    
    public var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    PassportImageView(passportImage: passportImage)
                    Divider()
                    PassportDetailsView(passportPreviewViewModel: passportPreviewViewModel)
                    SaveDeleteButtonsPassportView(passportPreviewViewModel: passportPreviewViewModel)
                    Divider()
                }
                .padding(.bottom, 16)
                .frame(maxWidth: .infinity)
            }
            .onAppear {
                print("PassportPreviewSheet appeared with origin: \(origin)")
                if origin == .imagePicker && passportImage == nil {
                    passportPreviewViewModel.isImagePickerOpen = true
                } else if origin == .cameraScanner && passportImage == nil {
                    passportPreviewViewModel.isCameraOpen = true
                }
            }
            .onChange(of: passportPreviewViewModel.passportImage) { _, newValue in
                if let unwrappedImage = newValue {
                    passportPreviewViewModel.processCapturedImage(unwrappedImage)
                } else {
                    print("No image to process")
                }
            }
            .onChange(of: passportImage) { newImage in
                if let unwrappedImage = newImage {
                    passportPreviewViewModel.passportImage = unwrappedImage
                }
            }
            .fullScreenCover(isPresented: $passportPreviewViewModel.isCameraOpen, content: {
                VNDocumentCameraViewControllerRepresentable(scanResult: $passportImage)
                    .ignoresSafeArea()
            })
            .navigationTitle("Paspor")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(trailing: Button(action: {
                dismiss()
            }) {
                Image(systemName: "x.circle")
                    .font(.title)
                    .foregroundColor(Color.primary5)
            })
        }
    }
}

struct PassportImageView: View {
    var passportImage: UIImage?
    
    var body: some View {
        Group {
            if let passportImage = passportImage {
                Image(uiImage: passportImage)
                    .resizable()
                    .frame(height: 200)
                    .cornerRadius(24)
                    .padding()
            } else {
                RoundedRectangle(cornerRadius: 24)
                    .fill(Color.gray)
                    .frame(height: 200)
                    .overlay {
                        VStack {
                            Image(systemName: "dock.rectangle")
                                .resizable()
                                .frame(width: 96, height: 64)
                                .foregroundStyle(Color.white)
                                .padding()
                                
                            Text("Gambarmu belum ada... \n Mungkin kamera akan segera diaktifkan.")
                                .font(.custom("Inter", size: 16))
                                .foregroundStyle(Color.white)
                                .multilineTextAlignment(.center)
                                .padding()
                        }
                    }
                    .padding()
                

            }
        }
    }
}

struct PassportDetailsView: View {
    @ObservedObject var passportPreviewViewModel: PassportPreviewViewModel
    
    var body: some View {
        VStack {
            HStack {
                Text("Perhatikan hasil scan dokumen")
                    .font(.headline)
                Image(systemName: "chevron.right")
                Spacer()
            }
            .padding(.horizontal)
            
            CardContainer(cornerRadius: 24) {
                VStack {
                    Group {
                        KeyValueDropdownRow<PassportType>(key: "Passport Type", selectedOption: $passportPreviewViewModel.passport.passportType)
                        KeyValueDropdownRow<PassportIssueType>(key: "Passport Issue Type", selectedOption: $passportPreviewViewModel.passport.passportIssueType)
                        KeyValueRow(key: "Tempat Penerbitan", value: $passportPreviewViewModel.passport.passportIssuePlace)
                        KeyValueDateRow(key: "Tanggal Penerbitan", dateValue: $passportPreviewViewModel.passport.issueDate)
                        KeyValueDateRow(key: "Tanggal Kadaluarsa", dateValue: $passportPreviewViewModel.passport.expirationDate)
                        KeyValueRow(key: "Nomor Passport", value: $passportPreviewViewModel.passport.passportNo)
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 4)
                }
            }
        }
    }
}

struct SaveDeleteButtonsPassportView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var passportPreviewViewModel: PassportPreviewViewModel
    
    var body: some View {
        VStack {
            switch passportPreviewViewModel.savePassportState {
            case .loading:
                ProgressView("Menyimpan...")
                    .padding()
            case .error:
                Text("Eror menyimpan paspormu").foregroundColor(Color.danger5)
            case .success:
                Text("Paspormu sukses tersimpan").foregroundColor(Color.success6)
            case .idle:
                CustomButton(text: "Simpan", color: Color.primary5, fontSize: 17, cornerRadius: 14, paddingHorizontal: 16, paddingVertical: 16) {
                    Task {
                        await passportPreviewViewModel.savePassport()
                    }
                    dismiss()
                }
            }
            
            switch passportPreviewViewModel.deletePassportState {
            case .loading:
                ProgressView("Menghapus...")
                    .padding()
            case .error:
                Text("Eror menghapus paspor").foregroundColor(Color.danger5)
            case .success:
                Text("Paspormu sukses terhapus").foregroundColor(Color.success6)
            case .idle:
                CustomButton(text: "Hapus dokumen", textColor: Color.primary5, color: .white, fontSize: 17, cornerRadius: 14, paddingHorizontal: 16, paddingVertical: 16) {
                    Task {
                        await passportPreviewViewModel.deletePassport()
                    }
                    dismiss()
                }
            }
        }
    }
}

