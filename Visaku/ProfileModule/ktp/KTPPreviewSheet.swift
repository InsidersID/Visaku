import SwiftUI
import UIComponentModule
import RepositoryModule

public struct KTPPreviewSheet: View {
    @Environment(\.dismiss) var dismiss
    @State var ktpPreviewViewModel: KTPPreviewViewModel
    
    public init(account: AccountEntity) {
        self.ktpPreviewViewModel = KTPPreviewViewModel(account: account)
    }
    
    public var body: some View {
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
                    ProgressView("Saving...")
                        .padding()
                case .error:
                    Text("Error saving the KTP").foregroundColor(.red)
                case .success:
                    Text("KTP saved successfully").foregroundColor(.green)
                case .idle:
                    CustomButton(text: "Simpan", color: .blue, font: 17, cornerRadius: 14, paddingHorizontal: 16, paddingVertical: 16) {
                        Task {
                            await ktpPreviewViewModel.saveIdentityCard()
                        }
//                        dismiss()
                    }
                }

                // Handle the different states of the delete operation
                switch ktpPreviewViewModel.deleteIdentityCardState {
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
                            await ktpPreviewViewModel.deleteIdentityCard()
                        }
//                        dismiss()
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
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
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
//                    dismiss()
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