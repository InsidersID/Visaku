import SwiftUI
import UniformTypeIdentifiers

// Step 1: FilePicker Struct
struct FilePicker: UIViewControllerRepresentable {
    @Binding var selectedFileURL: URL?
    @Environment(\.presentationMode) var presentationMode

    // Step 2: Coordinator to handle file selection
    class Coordinator: NSObject, UIDocumentPickerDelegate {
        let parent: FilePicker
        
        init(parent: FilePicker) {
            self.parent = parent
        }
        
        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            parent.presentationMode.wrappedValue.dismiss()
            
            // Take the first selected file URL
            if let url = urls.first {
                parent.selectedFileURL = url
            }
        }
        
        func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
            parent.presentationMode.wrappedValue.dismiss()
        }
    }

    // Step 3: Creating the Coordinator
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    // Step 4: Creating the UIDocumentPickerViewController
    func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
        let picker = UIDocumentPickerViewController(forOpeningContentTypes: [.item])
        picker.delegate = context.coordinator
        picker.allowsMultipleSelection = false  // Allow only one file selection
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: Context) {}
}

// Main View to Show the File Picker and Display Selected File URL
struct FilePickerView: View {
    @State private var selectedFileURL: URL?
    @State private var isFilePickerPresented = false
    
    var body: some View {
        VStack {
            if let selectedFileURL = selectedFileURL {
                Text("Selected file: \(selectedFileURL.lastPathComponent)")
                    .foregroundColor(.blue)
                    .padding()
            } else {
                Text("No file selected")
                    .foregroundColor(.gray)
                    .padding()
            }
            
            Button("Select File") {
                isFilePickerPresented = true
            }
            .padding()
            .sheet(isPresented: $isFilePickerPresented) {
                FilePicker(selectedFileURL: $selectedFileURL)
            }
        }
    }
}

#Preview {
    FilePickerView()
}
