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
    @State private var isFirstLaunch = !UserDefaults.standard.bool(forKey: "isFirstLaunch")

    var body: some Scene {
        WindowGroup {
            NavigationStack {
                if isFirstLaunch {
                    SplashScreen(isFirstLaunch: $isFirstLaunch)
                } else {
                    TabBarView()
                        .task {
                            SwiftDataContextManager()
                        }
                }
            }
        }
    }
}
