//
//  BakimApp.swift
//  Bakim
//
//  Created by Feyzullah Durası on 26.09.2024.
//

import SwiftUI

@main
struct BakimApp: App {
    @AppStorage("userTheme") private var userTheme: Theme = .systemDefault
    
    var body: some Scene {
        WindowGroup {
            LocalizedViewWrapper {
                SplashView()
                    //.preferredColorScheme(userTheme.colorScheme)
            }
        }
    }
}
