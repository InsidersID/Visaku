//
//  PDFDownload.swift
//  Visaku
//
//  Created by Lonard Steven on 17/11/24.
//

import Foundation
import SwiftUI

class PDFDownload: NSObject, UIDocumentInteractionControllerDelegate {
    static let shared = PDFDownload()
    private var documentController: UIDocumentInteractionController?
    
    private override init() {}

    func downloadPDF(completion: @escaping () -> Void) {
        guard let pdfURL = Bundle.main.url(forResource: "visa_form", withExtension: "pdf") else {
            print("PDF file not found")
            return
        }

        guard let destinationURL = savePDFToDocumentsDirectory(pdfURL: pdfURL) else {
            print("Failed to save PDF")
            return
        }

        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootVC = windowScene.windows.first?.rootViewController {
            if let presentedVC = rootVC.presentedViewController {
                presentedVC.dismiss(animated: true) {
                    self.presentShareSheet(for: destinationURL, in: rootVC) {
                        print("Downloading PDF...")
                        print("PDF download completed")
                        completion()
                    }
                }
            } else {
                // Present share sheet directly if no other modal is presented
                presentShareSheet(for: destinationURL, in: rootVC) {
                    print("Downloading PDF...")
                    print("PDF download completed")
                    completion()
                }
            }
        } else {
            print("Unable to present share sheet")
        }
    }

    func savePDFToDocumentsDirectory(pdfURL: URL) -> URL? {
        let fileManager = FileManager.default
        let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        let destinationURL = documentsDirectory.appendingPathComponent(pdfURL.lastPathComponent)
        
        do {
            if !fileManager.fileExists(atPath: destinationURL.path) {
                try fileManager.copyItem(at: pdfURL, to: destinationURL)
            }
            return destinationURL
        } catch {
            print("Error saving PDF to Documents directory: \(error.localizedDescription)")
            return nil
        }
    }

    func presentShareSheet(for url: URL, in viewController: UIViewController, completion: @escaping () -> Void) {
        DispatchQueue.main.async {
            self.documentController = UIDocumentInteractionController(url: url)
            self.documentController?.delegate = self
            self.documentController?.presentOpenInMenu(from: viewController.view.bounds, in: viewController.view, animated: true)

            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                completion()
            }
        }
    }
}
