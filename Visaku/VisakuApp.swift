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
    
    let manager = AgreementManager()

    var body: some Scene {
        WindowGroup {
            TabBarView()
                .task {
                    SwiftDataContextManager()
                }
        }
    }
}
