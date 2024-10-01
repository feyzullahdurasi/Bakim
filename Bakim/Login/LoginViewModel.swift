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
        
            /*guard let presentingViewController = getRootViewController() else {
                print("Presenting view controller is missing.")
                return
            }
            
            GIDSignIn.sharedInstance.signIn(withPresenting: presentingViewController) { signInResult, error in
                if let error = error {
                    print("Error during Google Sign-In: \(error.localizedDescription)")
                    return
                }
                
                guard let signInResult = signInResult else {
                    print("Sign-In result is missing.")
                    return
                }
                
                let user = signInResult.user
                // Google'dan gelen kullanıcı verileri
                let userId = user.userID ?? ""
                let fullName = user.profile?.name ?? ""
                let email = user.profile?.email ?? ""
                
                print("User ID: \(userId)")
                print("User Name: \(fullName)")
                print("User Email: \(email)")
                
                // Burada, veritabanınıza veya API'nize bu verileri kaydedin.
                self.saveUserDataToDatabase(userId: userId, fullName: fullName, email: email)
            }*/
    }
    
    func getRootViewController() -> UIViewController {
        guard let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            return UIViewController()
        }
        guard let root = screen.windows.first?.rootViewController else {
            return UIViewController()
        }
        return root
    }
    
    func saveUserDataToDatabase(userId: String, fullName: String, email: String) {
        // Sunucunuza veya veritabanınıza kaydetme işlemini burada gerçekleştirin
        // Örneğin, URLSession ile bir POST isteği gönderin
        let url = URL(string: "https://your-api.com/login")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let bodyData = "userId=\(userId)&fullName=\(fullName)&email=\(email)"
        request.httpBody = bodyData.data(using: .utf8)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error saving user data: \(error.localizedDescription)")
                return
            }
            
            if let response = response as? HTTPURLResponse, response.statusCode == 200 {
                print("User data saved successfully.")
            } else {
                print("Failed to save user data.")
            }
        }
        task.resume()
    }
}


