//
//  APIService.swift
//  Bakim
//
//  Created by Feyzullah Durası on 2.10.2024.
//

import Foundation
import UIKit

class NetworkService {
    
    static let shared = NetworkService()
    private let cache = NSCache<NSString, UIImage>()
    
    static let baseURL = "http://localhost:3000"
    
    private init() {}
    
    /// Bakım Verilerini Çeker
    func getBakim(completed: @escaping (Result<[Bakim], APIError>) -> Void) {
        guard let url = URL(string: NetworkService.baseURL) else {
            completed(.failure(.invalidURL))
            return
        }
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, response, error in
            if let error = error {
                print("Request failed: \(error.localizedDescription)")
                completed(.failure(.unableToComplete))
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completed(.failure(.invalidResponse))
                return
            }
            
            guard let data = data else {
                completed(.failure(.invalidData))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let decodedResponse = try decoder.decode([Bakim].self, from: data)
                DispatchQueue.main.async {
                    completed(.success(decodedResponse))
                }
            } catch {
                print("Decoding error: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    completed(.failure(.invalidData))
                }
            }
        }
        
        task.resume()
    }
    
    /// Görüntü İndirir
    func downloadImage(from urlString: String, completion: @escaping (UIImage?) -> Void) {
        let cacheKey = NSString(string: urlString)
        
        // Ön bellekte kontrol et
        if let cachedImage = cache.object(forKey: cacheKey) {
            completion(cachedImage)
            return
        }
        
        // URL'yi doğrula
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        
        // Görüntüyü indir
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            if let error = error {
                print("Image download failed: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            guard let data = data, let image = UIImage(data: data) else {
                completion(nil)
                return
            }
            
            // Görüntüyü ön belleğe ekle
            self?.cache.setObject(image, forKey: cacheKey)
            DispatchQueue.main.async {
                completion(image)
            }
        }
        
        task.resume()
    }
}

enum APIError: Error {
    case invalidURL
    case invalidResponse
    case invalidData
    case unableToComplete
    
    var userErrorMessage: String {
        switch self {
        case .invalidURL:
            return "Geçersiz bir URL ile karşılaşıldı. Lütfen URL'yi kontrol edin."
        case .invalidResponse:
            return "Sunucu yanıtında bir hata oluştu. Durum kodu: ."
        case .unableToComplete:
            return "İnternette bir hata oluştu. Lütfen daha sonra tekrar deneyin."
        case .invalidData:
            return "Geçersiz veri."
        }
    }
}
