//
//  VisakuApp.swift
//  Visaku
//
//  Created by hendra on 18/09/24.
//

import SwiftUI
import RepositoryModule
import OnboardingModule

@main
struct VisakuApp: App {
    var body: some Scene {
        WindowGroup {
            OnboardingView(destination: TabBarView())
                .task {
                    SwiftDataContextManager()
                }
        }
    }
}
