//
//  SkinVaultApp.swift
//  SkinVault
//
//  Created by Gordon on 2023-09-08.
//

import SwiftUI

@main
struct SkinVaultApp: App {
    var body: some Scene {
        WindowGroup {
            SplashScreenView()
        }
        .modelContainer(for: [Skin.self, Levels.self, Chromas.self])
    }
}
