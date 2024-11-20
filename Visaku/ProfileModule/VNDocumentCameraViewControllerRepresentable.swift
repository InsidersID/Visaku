import Foundation
import UIKit
import SwiftUI
import VisionKit

struct VNDocumentCameraViewControllerRepresentable: UIViewControllerRepresentable {
    @Binding var scanResult: UIImage?
    
    func makeUIViewController(context: Context) -> VNDocumentCameraViewController {
        let documentCameraViewController = VNDocumentCameraViewController()
        documentCameraViewController.delegate = context.coordinator
        
        return documentCameraViewController
    }
    
    func updateUIViewController(_ uiViewController: VNDocumentCameraViewController, context: Context) { }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(scanResult: $scanResult)
    }
    
    final class Coordinator: NSObject, @preconcurrency VNDocumentCameraViewControllerDelegate {
        @Binding var scanResult: UIImage?
        
        init(scanResult: Binding<UIImage?>) {
            _scanResult = scanResult
        }
        
        /// Tells the delegate that the user successfully saved a scanned document from the document camera.
        @MainActor
        func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
            if scan.pageCount > 0 {
                let firstImage = scan.imageOfPage(at: 0)
                DispatchQueue.main.async {
                    self.scanResult = firstImage
                    controller.dismiss(animated: true, completion: nil)
                }
                print("Scan successful. Image captured: \(firstImage)")
            } else {
                DispatchQueue.main.async {
                    self.scanResult = nil
                    controller.dismiss(animated: true, completion: nil)
                }
                print("Scan completed but no pages were captured.")
            }
        }
        
        // Tells the delegate that the user canceled out of the document scanner camera.
        @MainActor
        func documentCameraViewControllerDidCancel(_ controller: VNDocumentCameraViewController) {
            controller.dismiss(animated: true, completion: nil)
        }
        
        /// Tells the delegate that document scanning failed while the camera view controller was active.
        @MainActor
        func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFailWithError error: Error) {
            controller.dismiss(animated: true, completion: nil)
        }
    }
}
