//
//  Helper.swift
//  Visaku
//
//  Created by Lonard Steven on 08/11/24.
//

import SwiftUI

class Helper {
    static func getStatusBarHeight() -> CGFloat {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            return windowScene.statusBarManager?.statusBarFrame.height ?? 0
        } else {
            return 0
        }
    }
}


