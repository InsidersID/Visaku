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
    
    // Initialize with AccountEntity
    public init(account: AccountEntity) {
        self.passportPreviewViewModel = PassportPreviewViewModel(account: account)
    }
    
    public var body: some View {
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
                    .background(Color.red)
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
                    ProgressView("Saving...")
                        .padding()
                case .error:
                    Text("Error saving the KTP").foregroundColor(.red)
                case .success:
                    Text("KTP saved successfully").foregroundColor(.green)
                case .idle:
                    CustomButton(text: "Simpan", color: .blue, font: 17, cornerRadius: 14, paddingHorizontal: 16, paddingVertical: 16) {
                        Task {
                            await passportPreviewViewModel.savePassport()
                        }
                        dismiss()
                    }
                }
                
                switch passportPreviewViewModel.deletePassportState {
                case .loading:
                    ProgressView("Deleting...")
                        .padding()
                case .error:
                    Text("Error deleting the KTP").foregroundColor(.red)
                case .success:
                    Text("KTP deleted successfully").foregroundColor(.green)
                case .idle:
                    CustomButton(text: "Hapus dokumen", textColor: .blue, color: .white, font: 17, cornerRadius: 14, paddingHorizontal: 16, paddingVertical: 16) {
                        Task {
                            await passportPreviewViewModel.deletePassport()
                        }
                        dismiss()
                    }
                }
            }
            
        }
        .frame(width: .infinity, height: .infinity)
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
        .navigationTitle("KTP")
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
