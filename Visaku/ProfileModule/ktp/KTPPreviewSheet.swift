import SwiftUI
import UIComponentModule
import RepositoryModule

public struct KTPPreviewSheet: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var ktpPreviewViewModel: KTPPreviewViewModel
    @Environment(ProfileViewModel.self) var profileViewModel
    
    var origin: KTPPreviewOrigin
    
    public init(account: AccountEntity, selectedImage: UIImage? = nil, origin: KTPPreviewOrigin) {
        self.ktpPreviewViewModel = KTPPreviewViewModel(account: account)
        self.origin = origin
        
        if let unwrappedImage = selectedImage {
            self.ktpPreviewViewModel.ktpImage = unwrappedImage
            self.ktpPreviewViewModel.processCapturedImage(unwrappedImage)
        }
    }
    
    public var body: some View {
        NavigationStack {
            ScrollView(.vertical, showsIndicators: true) {
                VStack {
                    KTPImageView(ktpImage: ktpPreviewViewModel.ktpImage)
                    Divider()
                    KTPDetailsView(ktpPreviewViewModel: ktpPreviewViewModel)
                    SaveDeleteButtonsView(ktpPreviewViewModel: ktpPreviewViewModel)
                }
                .padding(.bottom, 16)
                .frame(maxWidth: .infinity)
            }
            .fullScreenCover(isPresented: $ktpPreviewViewModel.isCameraOpen) {
                VNDocumentCameraViewControllerRepresentable(scanResult: $ktpPreviewViewModel.ktpImage)
                    .ignoresSafeArea()
            }
            .sheet(isPresented: Binding(
                get: { profileViewModel.isUploadImageForKTP },
                set: { profileViewModel.isUploadImageForKTP = $0 }
            )) {
                ImagePicker(selectedImage: Binding(
                    get: { ktpPreviewViewModel.ktpImage.map { IdentifiableImage(id: UUID(), image: $0) } },
                    set: { newImage in
                        if let newImage = newImage {
                            ktpPreviewViewModel.ktpImage = newImage.image
                        }
                    }
                ), documentType: .ktp)
                    .onDisappear {
                        handleOnDisappear()
                    }
            }
            .onAppear {
                ktpPreviewViewModel.isCameraOpen = (origin == .cameraScanner)
            }
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
    
    private func handleOnDisappear() {
        if let unwrappedImage = ktpPreviewViewModel.ktpImage {
             Task {
                 ktpPreviewViewModel.processCapturedImage(unwrappedImage)
             }
         }
    }
}

struct KTPImageView: View {
    var ktpImage: UIImage?
    
    var body: some View {
        Group {
            if let ktpImage = ktpImage {
                Image(uiImage: ktpImage)
                    .resizable()
                    .frame(height: 200)
                    .cornerRadius(24)
                    .padding()
            } else {
                RoundedRectangle(cornerRadius: 24)
                    .fill(Color.gray)
                    .frame(width: 200, height: 200)
                    .overlay {
                        VStack {
                            Image(systemName: "dock.rectangle")
                                .resizable()
                                .frame(width: 64, height: 64)
                                .foregroundStyle(.white)
                                .padding()
                                
                            Text("Gambarmu belum ada... \n Mungkin kamera akan segera diaktifkan.")
                                .font(.custom("Inter", size: 16))
                                .foregroundStyle(.white)
                                .multilineTextAlignment(.center)
                                .padding()
                        }
                    }
                

            }
        }
    }
}

struct KTPDetailsView: View {
    @ObservedObject var ktpPreviewViewModel: KTPPreviewViewModel
    
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
    }
}

struct SaveDeleteButtonsView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var ktpPreviewViewModel: KTPPreviewViewModel
    
    var body: some View {
        VStack {
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
}

//#Preview {
//    KTPPreviewView()
//}
