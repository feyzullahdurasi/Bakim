//
//  SplashView.swift
//  Bakim
//
//  Created by Feyzullah Durası on 2.10.2024.
//

import SwiftUI

struct SplashView: View {
    @AppStorage("isLoggedIn") private var isLoggedIn: Bool = false
    @State private var navigateToNextScreen: Bool = false

    var body: some View {
        NavigationStack {
            VStack {
                Text("Bakim")
                    .font(.title)
                    .padding()
                    .fontWeight(.bold)

                // Navigation logic
                if navigateToNextScreen {
                    if isLoggedIn {
                        // Navigate to InfoView if logged in
                        InfoView()
                    } else {
                        LoginView()
                    }
                }
            }
        }
        .onAppear {
            // Simulate a delay to show the splash screen, then navigate
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                navigateToNextScreen = true
            }
        }
    }
}

#Preview {
    SplashView()
}
