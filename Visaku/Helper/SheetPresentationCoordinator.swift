//
//  SheetPresentationCoordinator.swift
//  Visaku
//
//  Created by Lonard Steven on 15/11/24.
//

import SwiftUI
import Foundation

@Observable
class SheetPresentationCoordinator: ObservableObject {
    static let shared = SheetPresentationCoordinator()

    var isKTPPreviewSheetPresented = false
    var isImagePickerPresented = false
    
    private var presentationQueue = [() -> Void]()
    private var isTransitioning = false

    func present(sheet: @escaping () -> Void) {
        presentationQueue.append(sheet)
        processQueue()
    }
    
    private func processQueue() {
        guard !isTransitioning, !presentationQueue.isEmpty else { return }
        
        isTransitioning = true
        let sheetToPresent = presentationQueue.removeFirst()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            sheetToPresent()
        }
    }

    func transitionCompleted() {
        isTransitioning = false
        processQueue()
    }
}
