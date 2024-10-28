//
//  LoginViewModel.swift
//  Bakim
//
//  Created by Feyzullah Durası on 1.10.2024.
//

import Foundation
import Combine

// UserType enum'u
enum UserType: String {
    case regular = "regular"
    case businessOwner = "businessOwner"
}

// User model
struct User {
    let email: String
    let userType: UserType
}

// AuthService güncelleme
class AuthService {
    func login(email: String, password: String, completion: @escaping (Result<User, Error>) -> Void) {
        DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
            // Simüle edilmiş kullanıcı kontrolleri
            switch (email, password) {
            case ("1", "1"):
                let user = User(email: email, userType: .regular)
                completion(.success(user))
            case ("2", "2"):
                let user = User(email: email, userType: .businessOwner)
                completion(.success(user))
            default:
                completion(.failure(NSError(domain: "", code: 401,
                    userInfo: [NSLocalizedDescriptionKey: "Invalid credentials"])))
            }
        }
    }
    
    func loginWithGoogle(completion: @escaping (Result<User, Error>) -> Void) {
        // Google Sign In işlemleri burada yapılacak
        // Simülasyon için direkt regular user döndürüyoruz
        DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
            let user = User(email: "google@gmail.com", userType: .regular)
            completion(.success(user))
        }
    }
}

// LoginViewModel güncelleme
class LoginViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var isLoggedIn: Bool = false
    @Published var errorMessage: String? = nil
    @Published var currentUser: User? = nil
    @Published var isLoading: Bool = false
    
    private let authService = AuthService()
    
    func login() {
        guard !email.isEmpty, !password.isEmpty else {
            errorMessage = "E-posta ve şifre boş olamaz."
            return
        }
        
        isLoading = true
        authService.login(email: email, password: password) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let user):
                    self?.currentUser = user
                    self?.isLoggedIn = true
                    UserDefaults.standard.setValue(user.userType.rawValue, forKey: "userType")
                    UserDefaults.standard.setValue(user.email, forKey: "userEmail")
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    func loginWithGoogle() {
        isLoading = true
        authService.loginWithGoogle { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let user):
                    self?.currentUser = user
                    self?.isLoggedIn = true
                    UserDefaults.standard.setValue(user.userType.rawValue, forKey: "userType")
                    UserDefaults.standard.setValue(user.email, forKey: "userEmail")
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
}
