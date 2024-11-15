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
    var body: some Scene {
        WindowGroup {
            TabBarView()
                .task {
                    SwiftDataContextManager()
                }
        }
    }
}
