//
//  CameraView.swift
//  CameraIntensityTest
//
//  Created by Lonard Steven on 24/10/24.
//

import UIKit
import AVFoundation
import CoreImage
import Combine
import Observation
import SwiftUI

class CameraView: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate, AVCapturePhotoCaptureDelegate {
    
    private var isAuthorized = false
    private var sessionQueue = DispatchQueue(label: "visaku.camera.session.queue", qos: .userInteractive)
    
    var captureSession: AVCaptureSession!
    var videoOutput: AVCaptureVideoDataOutput!
    var previewLayer: AVCaptureVideoPreviewLayer!
    
    var videoDevice: AVCaptureDevice?
    let photoOutput = AVCapturePhotoOutput()
    private var captureImageTriggered = false
    private let brightnessThreshold: CGFloat = 150.0
    
    private var shouldCaptureImageCancellable: AnyCancellable?
    
    @Published var lightCondition: String = "N/A"
    
    var currentCIImage: CIImage?
    
    @Binding var photoImage: UIImage?
    
    private var cameraState: CameraState
    private let onDismiss: () -> Void
    
    init(cameraState: CameraState, photoImage: Binding<UIImage?>, onDismiss: @escaping () -> Void) {
        self.cameraState = cameraState
        self._photoImage = photoImage
        self.onDismiss = onDismiss
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func checkPermission() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            isAuthorized = true
        case .notDetermined:
            requestPermission()
        default:
            isAuthorized = false
        }
    }
    
    func requestPermission() {
        sessionQueue.suspend()
        AVCaptureDevice.requestAccess(for: .video) { [unowned self] granted in
            isAuthorized = granted
            sessionQueue.resume()
        }
    }
    
    override func viewDidLoad() {
        checkPermission()
        
        sessionQueue.async {
            guard self.isAuthorized else { return }
            self.setupCamera()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupCameraPreviewLayer()
    }
    
    func setupCamera() {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self = self,
                let camera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back),
                let cameraInput = try? AVCaptureDeviceInput(device: camera) else {
                    print("Camera input couldn't be created.")
                    return
                }
            
            self.videoDevice = camera
            
            self.captureSession = AVCaptureSession()
            
            self.captureSession.beginConfiguration()
            self.captureSession.sessionPreset = .high
            
            do {
                try videoDevice?.lockForConfiguration()
                videoDevice?.exposureMode = .continuousAutoExposure
                videoDevice?.unlockForConfiguration()
            } catch {
                print("Couldn't lock the device for configuration, due to: \(error.localizedDescription)")
            }
            
            if camera.supportsSessionPreset(.hd4K3840x2160) {
                self.captureSession.sessionPreset = .hd4K3840x2160
            } else {
                self.captureSession.sessionPreset = .hd1920x1080
            }
            
            if self.captureSession.canAddInput(cameraInput) {
                self.captureSession.addInput(cameraInput)
            } else {
                print("Failed to add camera input")
            }
            
            self.videoOutput = AVCaptureVideoDataOutput()
            self.videoOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_32BGRA]
            
            if self.captureSession.canAddOutput(self.videoOutput) {
                self.captureSession.addOutput(self.videoOutput)
            } else {
                print("Failed to add video output")
            }
            
            self.videoOutput.setSampleBufferDelegate(self, queue: self.sessionQueue)
            self.videoOutput.alwaysDiscardsLateVideoFrames = false
            
            
            if let connection = self.videoOutput.connection(with: .video) {
                connection.isEnabled = true
                print("Video connected.")
            } else {
                print("No video connection found.")
            }
            
            self.captureSession.commitConfiguration()
            
            if !self.captureSession.isRunning {
                self.captureSession.startRunning()
            }
            
            self.observeExposureChanges()
            self.monitorCameraFocus()
            
            print("Capture session started: \(self.captureSession.isRunning)")
            
            DispatchQueue.main.async {
                self.setupCameraPreviewLayer()
                self.cameraState.isCameraFeedReady = true
            }
        }

    }
    
    func setupCameraPreviewLayer() {
        guard let captureSession = captureSession else {
            print("Capture session isn't ready yet to use. Sorry!")
            return
        }
        
        self.previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        self.previewLayer.videoGravity = .resizeAspectFill
        
        if let window = self.view.window {
            let safeAreaInsets = window.safeAreaInsets
            let safeAreaFrame = CGRect(x: 0, y: safeAreaInsets.top, width: self.view.bounds.width, height: self.view.bounds.height - safeAreaInsets.top)
            self.previewLayer.frame = safeAreaFrame
        } else {
            self.previewLayer.frame = self.view.bounds
        }
        
        self.view.layer.insertSublayer(self.previewLayer, at: 0)
    }
    
    func monitorCameraFocus() {
        guard let camera = videoDevice else { return }
        
        DispatchQueue.main.async {
            camera.addObserver(self, forKeyPath: "adjustingFocus", options: [.new, .old], context: nil)
        }
        
    }
    
    func observeExposureChanges() {
        guard let device = self.videoDevice else { return }
        
        device.addObserver(self, forKeyPath: "exposureTargetOffset", options: [.new, .old], context: nil)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "adjustingFocus" {
            if let camera = object as? AVCaptureDevice {
                cameraState.isFocused = !camera.isAdjustingFocus
                print("Camera focus state: \(cameraState.isFocused)")
            }
        }
        
        if keyPath == "exposureTargetOffset", let device = object as? AVCaptureDevice {
            cameraState.offset = device.exposureTargetOffset
            updateLightCondition(offset: cameraState.offset)
            print("Current light condition offset: \(cameraState.offset)")
        }
    }
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard cameraState.shouldCaptureImage else {
            return
        }
        
        print("aaaaa")
        guard let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            print("Image buffer is nil")
            return
        }
        
        let image = CIImage(cvImageBuffer: imageBuffer)
        currentCIImage = image
        print("Capture output received")
        
        print("isFocused: \(cameraState.isFocused), shouldCaptureImage: \(cameraState.shouldCaptureImage), offset: \(cameraState.offset)")
        
        if cameraState.isFocused && cameraState.shouldCaptureImage && cameraState.offset > -0.25 {
            print("Button tapped 2")
            
            if let capturedImage = capturePhoto(ciImage: image) {
                DispatchQueue.main.async {
                    self.photoImage = capturedImage
                }
//                onDismiss()
                print("Captured photo successfully: \(capturedImage)")
            } else {
                print("Failed to capture photo.")
            }
        }
    }
    
    func updateLightCondition(offset: Float) {
        if offset < -2.0 {
            lightCondition = "Very Dark"
        } else if offset < -1.0 {
            lightCondition = "Dark"
        } else if offset < 1.0 {
            lightCondition = "Normal"
        } else if offset < 2.0 {
            lightCondition = "Bright"
        } else {
            lightCondition = "Very Bright"
        }
    }
    
    func capturePhoto(ciImage: CIImage) -> UIImage? {
        print("Taking focused photo...")
        
        let context = CIContext(options: nil)
        
        if let cgImage = context.createCGImage(ciImage, from: ciImage.extent) {
            return UIImage(cgImage: cgImage, scale: 1.0, orientation: .right)
        }
        
        return nil
    }
    
    func addPreviewLayer(to view: UIView) {
        previewLayer.frame = view.bounds
        view.layer.addSublayer(previewLayer)
    }
    
    deinit {
        videoDevice?.removeObserver(self, forKeyPath: "adjustingFocus")
        videoDevice?.removeObserver(self, forKeyPath: "exposureTargetOffset")
    }
}
