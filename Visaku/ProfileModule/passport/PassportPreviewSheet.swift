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
    
    public init(account: AccountEntity, selectedImage: UIImage? = nil, origin: PassportPreviewOrigin) {
        self.passportPreviewViewModel = PassportPreviewViewModel(account: account)
        self.origin = origin
        
        if let unwrappedImage = selectedImage {
            self.passportPreviewViewModel.passportImage = unwrappedImage
            self.passportPreviewViewModel.processCapturedImage(unwrappedImage)
         } else {
             print("No image to process from ImagePicker, waiting for camera scan.")
         }
        
        if self.origin == .imagePicker {
            passportPreviewViewModel.isCameraOpen = false
        }
    }
    
    public var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    if let passportImage = passportPreviewViewModel.passportImage {
                        Image(uiImage: passportImage)
                            .resizable()
                            .frame(height: 200)
                            .cornerRadius(24)
                            .padding()
                    }
                    else {
                        Image(systemName: "dock.rectangle")
                            .resizable()
                            .frame(height: 200)
                            .background(Color.danger5)
                            .cornerRadius(24)
                            .padding()
                    }
                    Divider()
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
                .frame(width: .infinity)
            }
            .fullScreenCover(isPresented: $passportPreviewViewModel.isCameraOpen, content: {
                VNDocumentCameraViewControllerRepresentable(scanResult: $passportPreviewViewModel.passportImage)
                    .ignoresSafeArea()
            })
            .onChange(of: passportPreviewViewModel.passportImage) { _, newValue in
                if let unwrappedImage = newValue {
                    passportPreviewViewModel.processCapturedImage(unwrappedImage)
                } else {
                    print("No image to process")
                }
            }
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
