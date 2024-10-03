//
//  LoginViewModel.swift
//  Bakim
//
//  Created by Feyzullah Durası on 1.10.2024.
//

import Foundation
import SwiftUI
import GoogleSignIn
import GoogleSignInSwift

class LoginViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var isLoggedIn: Bool = false
    @Published var errorMessage: String?

    func login() {
        // E-posta ve şifre doğrulama
        guard !email.isEmpty, !password.isEmpty else {
            errorMessage = "Lütfen tüm alanları doldurun."
            return
        }
        
        // Burada giriş işlemi gerçekleştirilir (örneğin API çağrısı)
        if email == "test@example.com" && password == "password123" {
            isLoggedIn = true
        } else {
            errorMessage = "Geçersiz e-posta veya şifre."
        }
    }

    func loginWithGoogle() {
        
    }
            
}


