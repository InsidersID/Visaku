//
//  CameraViewRepresentable.swift
//  CameraIntensityTest
//
//  Created by Lonard Steven on 24/10/24.
//

import SwiftUI
import Combine

struct CameraViewRepresentable: UIViewControllerRepresentable {
    
    typealias UIViewControllerType = CameraView
    @Binding var photoImage: UIImage?
    
    @ObservedObject var cameraState: CameraState
    
    private let shouldCaptureImageSubject = PassthroughSubject<Bool, Never>()
    var onDismiss: () -> Void
    
    func makeUIViewController(context: Context) -> CameraView {
        let controller = CameraView(cameraState: cameraState, photoImage: $photoImage, onDismiss: onDismiss)
        return controller
    }
    
    func updateUIViewController(_ uiViewController: CameraView, context: Context) {
        
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    
    class Coordinator: NSObject {
        var parent: CameraViewRepresentable
        
        init(parent: CameraViewRepresentable) {
            self.parent = parent
        }
    }
}

