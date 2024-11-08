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

class CameraView: UIViewController, @preconcurrency AVCaptureVideoDataOutputSampleBufferDelegate, AVCapturePhotoCaptureDelegate {
    
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
    
    @Published var shouldCaptureImage = false
    @Published var lightCondition: String = "N/A"
    
    @Binding var photoImage: UIImage?
    
    var currentCIImage: CIImage?
    
    private var cameraState: CameraState
    
    init(cameraState: CameraState, photoImage: Binding<UIImage?>) {
        self.cameraState = cameraState
        self._photoImage = photoImage
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setShouldCaptureImagePublisher(_ publisher: PassthroughSubject<Bool, Never>) {
        shouldCaptureImageCancellable = publisher.sink { [weak self] newValue in
            self?.shouldCaptureImage = newValue
        }
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
        
        Task { @MainActor in
            guard self.isAuthorized else { return }
            
            setupCamera()
        }
 
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupCameraPreviewLayer()
    }
    
    func setupCamera() {
        Task { @MainActor in
            
            guard let camera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back),
                let cameraInput = try? AVCaptureDeviceInput(device: camera) else {
                    print("Camera input couldn't be created.")
                    return
                }
            
            captureSession = AVCaptureSession()
            
            captureSession.beginConfiguration()
            captureSession.sessionPreset = .high
            
            do {
                try camera.lockForConfiguration()
                camera.exposureMode = .continuousAutoExposure
                camera.unlockForConfiguration()
            } catch {
                print("Couldn't lock the device for configuration, due to: \(error.localizedDescription)")
            }
            
            if camera.supportsSessionPreset(.hd4K3840x2160) {
                captureSession.sessionPreset = .hd4K3840x2160
            } else {
                captureSession.sessionPreset = .hd1920x1080
            }
            
            if captureSession.canAddInput(cameraInput) {
                captureSession.addInput(cameraInput)
            } else {
                print("Failed to add camera input")
            }
            
            videoOutput = AVCaptureVideoDataOutput()
            videoOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_32BGRA]
            
            if captureSession.canAddOutput(self.videoOutput) {
                captureSession.addOutput(self.videoOutput)
            } else {
                print("Failed to add video output")
            }
            
            videoOutput.setSampleBufferDelegate(self, queue: self.sessionQueue)
            videoOutput.alwaysDiscardsLateVideoFrames = false
            
            if let connection = videoOutput.connection(with: .video) {
                connection.isEnabled = true
                print("Video connected.")
            } else {
                print("No video connection found.")
            }
            
            captureSession.commitConfiguration()
            
            if !captureSession.isRunning {
                captureSession.startRunning()
            }
            
            print("Capture session started: \(self.captureSession.isRunning)")
            
            self.videoDevice = camera
            self.captureSession = captureSession
            self.videoOutput = videoOutput
            
            self.observeExposureChanges()
            self.monitorCameraFocus()
            
            self.setupCameraPreviewLayer()
            self.cameraState.isCameraFeedReady = true
        }

    }
    
    @MainActor
    func setupCameraPreviewLayer() {
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
    
    @MainActor
    func monitorCameraFocus() {
        guard let camera = videoDevice else { return }
        
        camera.addObserver(self, forKeyPath: "adjustingFocus", options: [.new, .old], context: nil)
        
    }
    
    @MainActor
    func observeExposureChanges() {
        guard let device = self.videoDevice else { return }
        
        device.addObserver(self, forKeyPath: "exposureTargetOffset", options: [.new, .old], context: nil)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if keyPath == "adjustingFocus" {
            if let camera = object as? AVCaptureDevice {
                let isFocused = !camera.isAdjustingFocus
                DispatchQueue.main.async { [self] in
                    self.cameraState.isFocused = isFocused
                    print("Camera focus state: \(self.cameraState.isFocused)")
                }
            }
        }
        
        if keyPath == "exposureTargetOffset", let device = object as? AVCaptureDevice {
            let offset = device.exposureTargetOffset
            DispatchQueue.main.async {
                self.cameraState.offset = offset
                self.updateLightCondition(offset: self.cameraState.offset)
                print("Current light condition offset: \(self.cameraState.offset)")
            }
        }
        
    }
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            print("Image buffer is nil")
            return
        }
        
        let image = CIImage(cvImageBuffer: imageBuffer)
        let isFocused = cameraState.isFocused
        let offset = cameraState.offset
        let shouldCapture = shouldCaptureImage

        Task { @MainActor in
            print("aaaaa")
            
            currentCIImage = image
            print("Capture output received")
            
            print("isFocused: \(cameraState.isFocused), shouldCaptureImage: \(shouldCaptureImage), offset: \(cameraState.offset)")
            
            guard shouldCaptureImage else {
                return
            }
            
            if cameraState.isFocused && shouldCaptureImage && cameraState.offset > -0.25 {
                print("Button tapped 2")
                shouldCaptureImage = false
                
                if let capturedImage = capturePhoto(ciImage: image) {
                    self.photoImage = capturedImage
                    print("Captured photo successfully: \(capturedImage)")
                } else {
                    print("Failed to capture photo.")
                }
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
            return UIImage(cgImage: cgImage)
        }
        
        return nil
    }
    
    func addPreviewLayer(to view: UIView) {
        previewLayer.frame = view.bounds
        view.layer.addSublayer(previewLayer)
    }
    
    deinit {
        Task { [weak self] in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                if let videoDevice = self.videoDevice {
                    videoDevice.removeObserver(self, forKeyPath: "adjustingFocus")
                    videoDevice.removeObserver(self, forKeyPath: "exposureTargetOffset")
                }
            }
        }
    }
}
