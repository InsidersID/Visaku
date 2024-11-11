//
//  CameraOverlayView.swift
//  CameraIntensityTest
//
//  Created by Lonard Steven on 05/11/24.
//

import SwiftUI

struct CameraOverlayView: View {
    @Binding var goToCamera: Bool
    @ObservedObject var cameraState: CameraState
    
    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    goToCamera.toggle()
                }) {
                    Circle()
                        .fill(.black.opacity(25.0))  .frame(width: 44, height: 44)
                        .overlay {
                            Image(systemName: "xmark")
                                .padding()
                        }
                }
                .frame(width: 80, height: 44)
                .foregroundStyle(.white)
                
                .padding(.leading, 4)
                Spacer()
            }
            
            .padding(.top, 16)
            Spacer()
            
            HStack {
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.white.opacity(0.7))
                    .frame(height: 50)
                    .overlay {
                        getMessageOverlay()
                    }
                    .padding(.horizontal, 16)
            }
            .padding(.bottom, 71)


            Button(action: {
                cameraState.shouldCaptureImage = true
                cameraState.isTakingImage = true
                goToCamera.toggle()
                print("Button pressed")
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    cameraState.isTakingImage = false
                    cameraState.shouldCaptureImage = false
                }
            }) {
                
                
                Circle()
                    .fill(.white)
                    .frame(width: 66, height: 66)
                    .padding(.all, 5)
                    .overlay(
                        Circle()
                            .stroke(Color.white, lineWidth: 3)
                    )
                    .shadow(radius: 5)
            }
            .padding(.bottom, 35)
        }
    }
    
    private func getMessageOverlay() -> some View {
        Group {
            if !cameraState.isCameraFeedReady {
                HStack {
                    Text("Menunggu kamera diaktifkan... ")
                        .foregroundStyle(.black)
                        .font(.system(size: 18, weight: .medium))
                    
                    Image(systemName: "hourglass")
                        .foregroundStyle(.brown)
                }
            } else {
                if !cameraState.isFocused {
                    HStack {
                        Text("Kamera masih blur")
                            .foregroundStyle(.red)
                            .font(.system(size: 18, weight: .medium))
                    }
                } else if cameraState.offset < -0.1 {
                    HStack {
                        Text("Cahaya terlalu gelap")
                            .foregroundStyle(.red)
                            .font(.system(size: 18, weight: .medium))
                    }
                } else if cameraState.isTakingImage {
                    HStack {
                        Text("Gambar lagi diambil... ")
                            .foregroundStyle(.black)
                            .font(.system(size: 18, weight: .medium))
                        
                        Image(systemName: "hourglass")
                            .foregroundStyle(.brown)
                    }
                } else {
                    HStack {
                        Text("Foto sesuai")
                            .foregroundStyle(.black)
                            .font(.system(size: 18, weight: .medium))
                        
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundStyle(.green)
                    }
                }
                }
            }
        }
    }

