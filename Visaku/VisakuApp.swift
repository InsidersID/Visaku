//
//  VisakuApp.swift
//  Visaku
//
//  Created by hendra on 18/09/24.
//

import SwiftUI
import RepositoryModule

@main
struct VisakuApp: App {
    
    let manager = FirstTimeUseManager()

    var body: some Scene {
        WindowGroup {
            if manager.checkAndSetFirstUse() {
                SplashScreen()
                    .task {
                        SwiftDataContextManager()
                    }
            } else {
                TabBarView()
                    .task {
                        SwiftDataContextManager()
                    }
            }
        }
    }
}
