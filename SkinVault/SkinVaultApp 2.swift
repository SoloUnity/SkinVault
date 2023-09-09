//
//  SkinVaultApp.swift
//  SkinVault
//
//  Created by Gordon on 2023-09-06.
//

import SwiftUI
import SwiftData

@main
struct SkinVaultApp: App {
    
    /*
    let modelContainer: ModelContainer
    
    init() {
        do {
            modelContainer = try ModelContainer(for: Skins.self)
        } catch {
            fatalError("Could not initialize ModelContainer")
        }
    }
    */
    var body: some Scene {
        WindowGroup {
            SplashScreenView()
        }
        .modelContainer(for: Skins.self)
    }
}
