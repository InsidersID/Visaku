//
//  KTPPreviewCoordinator.swift
//  Visaku
//
//  Created by Lonard Steven on 16/11/24.
//

import SwiftUI
import Foundation

public class KTPPreviewCoordinator: ObservableObject {
    @Published public var isImagePickerVisible = false
    @Published public var isKTPPreviewSheetVisible = true
    @Published public var isProcessingInProgress = false
}
