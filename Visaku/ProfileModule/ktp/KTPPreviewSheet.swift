import SwiftUI
import UIComponentModule
import RepositoryModule

public struct KTPPreviewSheet: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var ktpPreviewViewModel: KTPPreviewViewModel
    
    public init(account: AccountEntity, selectedImage: UIImage? = nil) {
        self.ktpPreviewViewModel = KTPPreviewViewModel(account: account)
        
        if let unwrappedImage = selectedImage {
             self.ktpPreviewViewModel.ktpImage = unwrappedImage
             self.ktpPreviewViewModel.processCapturedImage(unwrappedImage)
         } else {
             print("No image to process from ImagePicker, waiting for camera scan.")
         }
    }
    
    public var body: some View {
        NavigationStack {
            ScrollView(.vertical, showsIndicators: true) {
                VStack {
                    if let ktpImage = ktpPreviewViewModel.ktpImage {
                        Image(uiImage: ktpImage)
                            .resizable()
                            .frame(height: 200)
                            .cornerRadius(24)
                            .padding()
                    } else {
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
                                KeyValueRow(key: "NIK", value: $ktpPreviewViewModel.identityCard.identityId)
                                KeyValueRow(key: "Nama", value: $ktpPreviewViewModel.identityCard.name)
                                KeyValueRow(key: "TTL", value: $ktpPreviewViewModel.identityCard.placeDateOfBirth)
                                KeyValueRow(key: "Negara Kelahiran", value: $ktpPreviewViewModel.identityCard.countryBorn)
                                KeyValueRow(key: "Kewarganegaraan", value: $ktpPreviewViewModel.identityCard.nationality)
                                KeyValuePickerRow<GenderEnum>(key: "Gender", selectedOption: $ktpPreviewViewModel.identityCard.gender)
                                KeyValueDropdownRow(key: "Marital Status", selectedOption: $ktpPreviewViewModel.identityCard.maritalStatus)
                                KeyValueRow(key: "Pekerjaan", value: $ktpPreviewViewModel.identityCard.job)
                            }
                            .padding(.horizontal)
                            .padding(.vertical, 4)
                        }
                    }
                    
                    // Save and delete buttons
                    VStack {
                        // Handle the different states of the save operation
                        switch ktpPreviewViewModel.saveIdentityCardState {
                        case .loading:
                            ProgressView("Menyimpan...")
                                .padding()
                        case .error:
                            Text("Eror menyimpan KTP-mu").foregroundColor(.red)
                        case .success:
                            Text("KTP-mu sukses tersimpan").foregroundColor(.green)
                        case .idle:
                            CustomButton(text: "Simpan", color: .blue, fontSize: 17, cornerRadius: 14, paddingHorizontal: 16, paddingVertical: 16) {
                                Task {
                                    await ktpPreviewViewModel.saveIdentityCard()
                                }
                                dismiss()
                            }
                        }

                        // Handle the different states of the delete operation
                        switch ktpPreviewViewModel.deleteIdentityCardState {
                        case .loading:
                            ProgressView("Menghapus...")
                                .padding()
                        case .error:
                            Text("Eror menghapus KTP-mu").foregroundColor(.red)
                        case .success:
                            Text("KTP-mu sukses terhapus").foregroundColor(.green)
                        case .idle:
                            CustomButton(text: "Hapus dokumen", textColor: .blue, color: .white, fontSize: 17, cornerRadius: 14, paddingHorizontal: 16, paddingVertical: 16) {
                                Task {
                                    await ktpPreviewViewModel.deleteIdentityCard()
                                }
                                dismiss()
                            }
                        }
                    }
                }
                .padding(.bottom, 16)
                .frame(maxWidth: .infinity)
            }
            .fullScreenCover(isPresented: $ktpPreviewViewModel.isCameraOpen, content: {
                VNDocumentCameraViewControllerRepresentable(scanResult: $ktpPreviewViewModel.ktpImage)
                    .ignoresSafeArea()
            })
            .onChange(of: ktpPreviewViewModel.ktpImage) { _, newValue in
                if let unwrappedImage = newValue {
                    ktpPreviewViewModel.processCapturedImage(unwrappedImage)
                } else {
                    print("No image to process")
                }
            }
            .navigationTitle("KTP")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(trailing: Button(action: {
                dismiss()
            }) {
                Image(systemName: "x.circle")
                    .font(.title)
                    .foregroundColor(.blue)
            })
        }
    }
}

//#Preview {
//    KTPPreviewView()
//}
