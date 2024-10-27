//
//  LoginViewModel.swift
//  Bakim
//
//  Created by Feyzullah Durası on 1.10.2024.
//

import Foundation
import Combine

class LoginViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var isLoggedIn: Bool = false
    @Published var errorMessage: String? = nil
    
    private let authService = AuthService()
    
    // Giriş yapma fonksiyonu
    func login() {
        // Temel doğrulama
        guard !email.isEmpty, !password.isEmpty else {
            errorMessage = "E-posta ve şifre boş olamaz."
            return
        }
        
        // API üzerinden giriş yapma
        authService.login(email: email, password: password) { success, error in
            DispatchQueue.main.async {
                if success {
                    self.isLoggedIn = true
                } else {
                    self.errorMessage = error?.localizedDescription ?? "Giriş yaparken bir hata oluştu."
                }
            }
        }
    }
    
    // Google ile giriş yapma fonksiyonu
    func loginWithGoogle() {
        // Burada Google ile giriş mantığını ekleyin
        // Örneğin, Google Sign-In SDK'sını kullanarak giriş yapabilirsiniz
    }
}

// Örnek bir authentication service
class AuthService {
    func login(email: String, password: String, completion: @escaping (Bool, Error?) -> Void) {
        // Burada API çağrısını yaparak kullanıcıyı doğrulama işlemi yapılacak
        // Simulasyon için bir gecikme ekleyelim
        DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
            if email == "1" && password == "1" {
                completion(true, nil) // Başarılı giriş
            } else {
                completion(false, NSError(domain: "", code: 401, userInfo: [NSLocalizedDescriptionKey: "Invalid username or password."]))
            }
        }
    }
}


