import SwiftUI
import UIComponentModule
import RepositoryModule

public struct KTPPreviewSheet: View {
    @ObservedObject var ktpPreviewViewModel: KTPPreviewViewModel
    @Environment(ProfileViewModel.self) var profileViewModel
    
    @Environment(\.dismiss) var dismiss
    var origin: KTPPreviewOrigin
    
    @State private var ktpImage: UIImage?
    
    public init(account: AccountEntity, selectedImage: UIImage? = nil, origin: KTPPreviewOrigin) {
        self.ktpPreviewViewModel = KTPPreviewViewModel(account: account)
        self.origin = origin
        
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
                    KTPImageView(ktpImage: ktpImage)
                    Divider()
                    KTPDetailsView(ktpPreviewViewModel: ktpPreviewViewModel)
                    SaveDeleteButtonsView(ktpPreviewViewModel: ktpPreviewViewModel)
                }
                .padding(.bottom, 16)
                .frame(maxWidth: .infinity)
            }
            .onAppear {
                print("KTPPreviewSheet appeared with origin: \(origin)")
                if origin == .imagePicker && ktpImage == nil {
                    ktpPreviewViewModel.isImagePickerOpen = true
                } else if origin == .cameraScanner && ktpImage == nil {
                    ktpPreviewViewModel.isCameraOpen = true
                }
            }
            .onChange(of: ktpPreviewViewModel.ktpImage) { _, newValue in
                guard let image = newValue else { return }
                print("Processing image in onChange...")
                Task {
                    await ktpPreviewViewModel.processCapturedImage(image)
                }
            }
            .onChange(of: ktpImage) { newImage in
                if let unwrappedImage = newImage {
                    ktpPreviewViewModel.ktpImage = unwrappedImage
                }
            }
            .fullScreenCover(isPresented: $ktpPreviewViewModel.isCameraOpen) {
                VNDocumentCameraViewControllerRepresentable(scanResult: $ktpImage)
                    .ignoresSafeArea()
            }
            .navigationTitle("KTP")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(trailing: Button(action: {
                print("Dismiss button tapped")
                dismiss()
            }) {
                Image(systemName: "x.circle")
                    .font(.title)
                    .foregroundColor(Color.primary5)
            })
        }
    }

}

//            .sheet(isPresented: $profileViewModel.isUploadImageForKTP) {
//                ImagePicker(selectedImage: $ktpPreviewViewModel.ktpImage)
//            }
//            .sheet(isPresented: $ktpPreviewViewModel.isImagePickerOpen) {
//                ImagePicker(selectedImage: $ktpPreviewViewModel.ktpImage)
//            }

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
                Text("Eror menyimpan KTP-mu").foregroundColor(Color.danger5)
            case .success:
                Text("KTP-mu sukses tersimpan").foregroundColor(Color.success6)
            case .idle:
                CustomButton(text: "Simpan", color: Color.primary5, fontSize: 17, cornerRadius: 14, paddingHorizontal: 16, paddingVertical: 16) {
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
                Text("Eror menghapus KTP-mu").foregroundColor(Color.danger5)
            case .success:
                Text("KTP-mu sukses terhapus").foregroundColor(Color.success6)
            case .idle:
                CustomButton(text: "Hapus dokumen", textColor: Color.primary5, color: .white, fontSize: 17, cornerRadius: 14, paddingHorizontal: 16, paddingVertical: 16) {
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
