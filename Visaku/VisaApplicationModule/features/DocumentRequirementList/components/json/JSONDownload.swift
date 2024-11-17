//
//  JSONDownload.swift
//  Visaku
//
//  Created by Lonard Steven on 17/11/24.
//

import Foundation
import SwiftUI

class JSONDownload: NSObject, UIDocumentInteractionControllerDelegate {
    static let shared = JSONDownload()
    
    private override init() {
        
    }
    
    func downloadJSON(completion: @escaping () -> Void) {
        guard let jsonURL = Bundle.main.url(forResource: "visa", withExtension: "json") else {
            print("JSON file not found")
            return
        }

        guard let destinationURL = saveJSONToDocumentsDirectory(jsonURL: jsonURL) else {
            print("Failed to save JSON")
            return
        }

        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootVC = windowScene.windows.first?.rootViewController {
            presentShareSheet(for: destinationURL, in: rootVC) {
                print("Downloading JSON...")
                print("JSON download completed")
                completion()
            }
        } else {
            print("Unable to present share sheet")
        }
    }

    func saveJSONToDocumentsDirectory(jsonURL: URL) -> URL? {
        let fileManager = FileManager.default
        let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        let destinationURL = documentsDirectory.appendingPathComponent(jsonURL.lastPathComponent)
        
        do {
            if !fileManager.fileExists(atPath: destinationURL.path) {
                try fileManager.copyItem(at: jsonURL, to: destinationURL)
            }
            return destinationURL
        } catch {
            print("Error saving JSON to Documents directory: \(error.localizedDescription)")
            return nil
        }
    }

    func presentShareSheet(for url: URL, in viewController: UIViewController, completion: @escaping () -> Void) {
            let documentController = UIDocumentInteractionController(url: url)
            documentController.delegate = self
            documentController.presentOptionsMenu(from: viewController.view.bounds, in: viewController.view, animated: true)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                completion()
            }
        }
}
