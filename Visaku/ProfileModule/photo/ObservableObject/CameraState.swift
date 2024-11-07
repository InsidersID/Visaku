//
//  CameraState.swift
//  CameraIntensityTest
//
//  Created by Lonard Steven on 04/11/24.
//

import SwiftUI
import Combine

class CameraState: ObservableObject {
    @Published var offset: Float = 0.0
    @Published var isFocused: Bool = true
    @Published var isCameraFeedReady: Bool = false
}

