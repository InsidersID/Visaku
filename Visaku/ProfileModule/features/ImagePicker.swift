import SwiftUI
import RepositoryModule
import PhotosUI

// Step 1: ImagePicker Struct
struct ImagePicker: UIViewControllerRepresentable {
    @Binding var selectedImage: IdentifiableImage?
    var documentType: AllDocumentType
    var onDocumentTypeSelected: ((AllDocumentType) -> Void)?
//    @Environment(\.presentationMode) var presentationMode
    
    // Step 2: Coordinator to handle user selection
    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        
        let parent: ImagePicker

        init(parent: ImagePicker) {
            self.parent = parent
        }

        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
                picker.dismiss(animated: true)

                guard let firstResult = results.first else {
                    print("No image selected")
                    return
                }

                firstResult.itemProvider.loadObject(ofClass: UIImage.self) { (object, error) in
                    if let error = error {
                        print("Failed to load image: \(error)")
                        return
                    }

                    if let image = object as? UIImage {
                        DispatchQueue.main.async {
                            self.parent.selectedImage = IdentifiableImage(image: image)
                        }
                    }
                }
            }
        }
    
    // Step 3: Creating the Coordinator
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }

    // Step 4: Creating the PHPickerViewController
    func makeUIViewController(context: Context) -> PHPickerViewController {
        var config = PHPickerConfiguration()
        config.filter = .images
        config.selectionLimit = 1

        let picker = PHPickerViewController(configuration: config)
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}
}

// Main View to Show the Image Picker and Display Image
//struct ImagePickerView: View {
//    @Binding var selectedImage: IdentifiableImage?
//    @State var isPickerPresented = false
//    
//    @State var isKTPPreviewPresentedFromPicker = false
//    @State var isPassportPreviewPresentedFromPicker = false
//    @State var isPhotoPreviewPresentedFromPicker = false
//    
//    @ObservedObject var account: AccountEntity
//    var documentType: AllDocumentType
//
//    var body: some View {
//        VStack {
//            if let image = selectedImage?.image {
//                Image(uiImage: image)
//                    .resizable()
//                    .scaledToFit()
//                    .frame(width: 200, height: 200)
//            } else {
//                Text("Belum ada gambar, upload dulu ya:(")
//                    .font(Font.custom("Inter", size: 20))
//                    .foregroundColor(.gray)
//            }
//            
//            Button("Select image") {
//                isPickerPresented = true
//            }
//            .padding()
//            .sheet(isPresented: $isPickerPresented, content: {
//                ImagePicker(selectedImage: $selectedImage, documentType: documentType)
//            })
//           .onChange(of: selectedImage) { newImage in
//                print("Selected image: \(String(describing: newImage))")
//               
//               if (newImage?.image) != nil {
//                   if documentType == .ktp {
//                       isKTPPreviewPresentedFromPicker = true
//                   } else if documentType == .paspor {
//                       isPassportPreviewPresentedFromPicker = true
//                   } else if documentType == .personalPhoto {
//                       isPassportPreviewPresentedFromPicker = true
//                   } else {
//                       isKTPPreviewPresentedFromPicker = true
//                   }
//               }
//            }
//           .sheet(isPresented: $isKTPPreviewPresentedFromPicker) {
//               if let uiImage = selectedImage?.image {
//                   KTPPreviewSheet(account: account, selectedImage: uiImage, origin: .)
//               }
//           }
//           .sheet(isPresented: $isPassportPreviewPresentedFromPicker) {
//               if let uiImage = selectedImage?.image {
//                   PassportPreviewSheet(account: account, selectedImage: uiImage)
//               }
//           }
//           .sheet(isPresented: $isPhotoPreviewPresentedFromPicker) {
//               if let uiImage = selectedImage?.image {
//                   PhotoPreviewSheet(account: account, photoImage: uiImage)
//               }
//           }
//        }
//    }
//}

//#Preview {
//    ImagePickerView(selectedImage: <#Binding<IdentifiableImage?>#>, account: AccountEntity(id: UUID().uuidString, username: "Andi", image: Data()), documentType: .ktp)
//}
