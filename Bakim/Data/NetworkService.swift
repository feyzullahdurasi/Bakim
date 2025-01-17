//
//  APIService.swift
//  Bakim
//
//  Created by Feyzullah Durası on 2.10.2024.
//

import Foundation
import UIKit

// MARK: - Authentication Models
struct LoginCredentials: Codable {
    let username: String
    let password: String
}

struct RegisterCredentials: Codable {
    let username: String
    let email: String
    let password: String
}

struct AuthResponse: Codable {
    let token: String
    let user: User
}

// MARK: - Network Errors
enum APIError: Error {
    case invalidURL
    case invalidResponse
    case invalidData
    case unableToComplete
    case authenticationError
    case serverError(String)
    case validationError([String])
    
    var errorMessage: String {
        switch self {
        case .invalidURL:
            return "Invalid URL. Please try again."
        case .invalidResponse:
            return "Invalid response from the server."
        case .invalidData:
            return "The data received was invalid."
        case .unableToComplete:
            return "Unable to complete your request."
        case .authenticationError:
            return "Authentication failed."
        case .serverError(let message):
            return message
        case .validationError(let errors):
            return errors.joined(separator: "\n")
        }
    }
}

// MARK: - NetworkService
final class NetworkService {
    static let shared = NetworkService()
    private let cache = NSCache<NSString, UIImage>()
    private let session = URLSession.shared
    
    private let baseURL = "http://localhost:3000/api"
    private var authToken: String? {
        didSet {
            UserDefaults.standard.set(authToken, forKey: "authToken")
        }
    }
    
    private init() {
        authToken = UserDefaults.standard.string(forKey: "authToken")
    }
    
    // MARK: - Generic Network Request
    private func performRequest<T: Codable>(endpoint: String,
                                          method: String = "GET",
                                          body: Data? = nil,
                                          requiresAuth: Bool = true,
                                          completion: @escaping (Result<T, APIError>) -> Void) {
        guard let url = URL(string: "\(baseURL)\(endpoint)") else {
            completion(.failure(.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if requiresAuth {
            guard let token = authToken else {
                completion(.failure(.authenticationError))
                return
            }
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        if let body = body {
            request.httpBody = body
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let _ = error {
                completion(.failure(.unableToComplete))
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
                completion(.failure(.invalidResponse))
                return
            }
            
            switch response.statusCode {
            case 200...299:
                guard let data = data else {
                    completion(.failure(.invalidData))
                    return
                }
                
                do {
                    let decoder = JSONDecoder()
                    let decodedResponse = try decoder.decode(T.self, from: data)
                    DispatchQueue.main.async {
                        completion(.success(decodedResponse))
                    }
                } catch {
                    print("Decoding error: \(error)")
                    completion(.failure(.invalidData))
                }
                
            case 401:
                completion(.failure(.authenticationError))
                self.handleAuthError()
            case 422:
                if let data = data,
                   let errors = try? JSONDecoder().decode([String].self, from: data) {
                    completion(.failure(.validationError(errors)))
                } else {
                    completion(.failure(.serverError("Validation failed")))
                }
            default:
                completion(.failure(.serverError("Server error with status code: \(response.statusCode)")))
            }
        }.resume()
    }
    
    // MARK: - Authentication
    func login(credentials: LoginCredentials, completion: @escaping (Result<AuthResponse, APIError>) -> Void) {
        guard let body = try? JSONEncoder().encode(credentials) else {
            completion(.failure(.invalidData))
            return
        }
        
        performRequest(endpoint: "/auth/login",
                      method: "POST",
                      body: body,
                      requiresAuth: false) { [weak self] (result: Result<AuthResponse, APIError>) in
            if case .success(let response) = result {
                self?.authToken = response.token
            }
            completion(result)
        }
    }
    
    func register(credentials: RegisterCredentials, completion: @escaping (Result<AuthResponse, APIError>) -> Void) {
        guard let body = try? JSONEncoder().encode(credentials) else {
            completion(.failure(.invalidData))
            return
        }
        
        performRequest(endpoint: "/auth/register",
                      method: "POST",
                      body: body,
                      requiresAuth: false,
                      completion: completion)
    }
    
    func logout() {
        authToken = nil
        UserDefaults.standard.removeObject(forKey: "authToken")
    }
    
    private func handleAuthError() {
        logout()
        NotificationCenter.default.post(name: .unauthorizedAccess, object: nil)
    }
    
    // MARK: - Users
    func getUsers(completion: @escaping (Result<[User], APIError>) -> Void) {
        performRequest(endpoint: "/users", completion: completion)
    }
    
    func getUser(id: Int, completion: @escaping (Result<User, APIError>) -> Void) {
        performRequest(endpoint: "/users/\(id)", completion: completion)
    }
    
    func updateUser(id: Int, user: User, completion: @escaping (Result<User, APIError>) -> Void) {
        guard let body = try? JSONEncoder().encode(user) else {
            completion(.failure(.invalidData))
            return
        }
        
        performRequest(endpoint: "/users/\(id)",
                      method: "PUT",
                      body: body,
                      completion: completion)
    }
    
    // MARK: - Businesses
    func getBusinesses(completion: @escaping (Result<[Business], APIError>) -> Void) {
        performRequest(endpoint: "/businesses", completion: completion)
    }
    
    func getBusiness(id: Int, completion: @escaping (Result<Business, APIError>) -> Void) {
        performRequest(endpoint: "/businesses/\(id)", completion: completion)
    }
    
    func createBusiness(business: Business, completion: @escaping (Result<Business, APIError>) -> Void) {
        guard let body = try? JSONEncoder().encode(business) else {
            completion(.failure(.invalidData))
            return
        }
        
        performRequest(endpoint: "/businesses",
                      method: "POST",
                      body: body,
                      completion: completion)
    }
    
    // MARK: - Reservations
    func getReservations(completion: @escaping (Result<[Reservation], APIError>) -> Void) {
        performRequest(endpoint: "/reservations", completion: completion)
    }
    
    func createReservation(reservation: Reservation, completion: @escaping (Result<Reservation, APIError>) -> Void) {
        guard let body = try? JSONEncoder().encode(reservation) else {
            completion(.failure(.invalidData))
            return
        }
        
        performRequest(endpoint: "/reservations",
                      method: "POST",
                      body: body,
                      completion: completion)
    }
    
    func updateReservationStatus(id: String, status: ReservationStatus, completion: @escaping (Result<Reservation, APIError>) -> Void) {
        let statusUpdate = ["status": status.rawValue]
        guard let body = try? JSONEncoder().encode(statusUpdate) else {
            completion(.failure(.invalidData))
            return
        }
        
        performRequest(endpoint: "/reservations/\(id)",
                      method: "PUT",
                      body: body,
                      completion: completion)
    }
    
    // MARK: - Bank Cards
    func getBankCards(completion: @escaping (Result<[BankCard], APIError>) -> Void) {
        performRequest(endpoint: "/bankcards", completion: completion)
    }
    
    func addBankCard(card: BankCard, completion: @escaping (Result<BankCard, APIError>) -> Void) {
        guard let body = try? JSONEncoder().encode(card) else {
            completion(.failure(.invalidData))
            return
        }
        
        performRequest(endpoint: "/bankcards",
                      method: "POST",
                      body: body,
                      completion: completion)
    }
    
    // MARK: - Service Types
    func getServiceTypes(completion: @escaping (Result<[ServiceType], APIError>) -> Void) {
        performRequest(endpoint: "/servicetypes", completion: completion)
    }
    
    // MARK: - Image Download and Caching
    func downloadImage(from urlString: String, completion: @escaping (UIImage?) -> Void) {
        let cacheKey = NSString(string: urlString)
        
        if let cachedImage = cache.object(forKey: cacheKey) {
            completion(cachedImage)
            return
        }
        
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self,
                  let data = data,
                  let image = UIImage(data: data) else {
                DispatchQueue.main.async {
                    completion(nil)
                }
                return
            }
            
            self.cache.setObject(image, forKey: cacheKey)
            DispatchQueue.main.async {
                completion(image)
            }
        }.resume()
    }
}

// MARK: - Notification Names
extension Notification.Name {
    static let unauthorizedAccess = Notification.Name("unauthorizedAccess")
}
extension APIError {
    var userErrorMessage: String {
        switch self {
        case .invalidURL:
            return "Geçersiz URL. Lütfen daha sonra tekrar deneyin."
        case .invalidResponse:
            return "Sunucudan geçersiz yanıt alındı."
        case .invalidData:
            return "Alınan veri geçersiz."
        case .unableToComplete:
            return "İşlem tamamlanamadı. İnternet bağlantınızı kontrol edin."
        case .authenticationError:
            return "Oturum süreniz doldu. Lütfen tekrar giriş yapın."
        case .serverError(let message):
            return "Sunucu hatası: \(message)"
        case .validationError(let errors):
            return errors.joined(separator: "\n")
        }
    }
}
extension NetworkService {
    func request<T: Decodable>(
        endpoint: String,
        method: String = "GET",
        body: Data? = nil,
        requiresAuth: Bool = true
    ) async throws -> T {
        guard let url = URL(string: "\(baseURL)\(endpoint)") else {
            throw APIError.invalidURL
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if requiresAuth {
            guard let token = authToken else {
                throw APIError.authenticationError
            }
            urlRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        if let body = body {
            urlRequest.httpBody = body
        }
        
        let (data, response) = try await session.data(for: urlRequest)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }
        
        switch httpResponse.statusCode {
        case 200...299:
            let decoder = JSONDecoder()
            return try decoder.decode(T.self, from: data)
        case 401:
            throw APIError.authenticationError
        case 422:
            if let errors = try? JSONDecoder().decode([String].self, from: data) {
                throw APIError.validationError(errors)
            }
            throw APIError.serverError("Validation failed")
        default:
            throw APIError.serverError("Server error with status code: \(httpResponse.statusCode)")
        }
    }
    
    func getBusinessServices(businessId: Int) async throws -> [Service] {
        return try await request(
            endpoint: "/businesses/\(businessId)/services"
        )
    }
    
    func createService(_ service: Service) async throws -> Service {
        return try await request(
            endpoint: "/services",
            method: "POST",
            body: try JSONEncoder().encode(service)
        )
    }
    
    func updateService(_ service: Service) async throws -> Service {
        return try await request(
            endpoint: "/services/\(service.id)",
            method: "PUT",
            body: try JSONEncoder().encode(service)
        )
    }
    
    func deleteService(serviceId: Int) async throws {
        _ = try await request(
            endpoint: "/services/\(serviceId)",
            method: "DELETE"
        ) as EmptyResponse
    }
}

struct EmptyResponse: Codable {}
