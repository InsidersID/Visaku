import SwiftUI
import PhotosUI

// Step 1: ImagePicker Struct
struct ImagePicker: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?
    @Environment(\.presentationMode) var presentationMode
    
    // Step 2: Coordinator to handle user selection
    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        let parent: ImagePicker
        
        init(parent: ImagePicker) {
            self.parent = parent
        }
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            
            // Check for results and load the selected image
            if let result = results.first, result.itemProvider.canLoadObject(ofClass: UIImage.self) {
                result.itemProvider.loadObject(ofClass: UIImage.self) { (image, error) in
                    DispatchQueue.main.async {
                        if let selectedImage = image as? UIImage {
                            self.parent.selectedImage = selectedImage
                        }
                        self.parent.presentationMode.wrappedValue.dismiss()
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
struct ImagePickerView: View {
    @State private var selectedImage: UIImage?
    @State private var isPickerPresented = false
    
    var body: some View {
        VStack {
            if let selectedImage = selectedImage {
                Image(uiImage: selectedImage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
            } else {
                Text("No image selected")
                    .foregroundColor(.gray)
            }
            
            Button("Select Image") {
                isPickerPresented = true
            }
            .padding()
            .sheet(isPresented: $isPickerPresented) {
                ImagePicker(selectedImage: $selectedImage)
            }
        }
    }
}

#Preview {
    ImagePickerView()
}
