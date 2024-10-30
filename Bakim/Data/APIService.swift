//
//  APIService.swift
//  Bakim
//
//  Created by Feyzullah Durası on 2.10.2024.
//

import Foundation

class APIService {
    
    static let shared = APIService()
    
    static let baseURL = "https://raw.githubusercontent.com/atilsamancioglu/BTK20-JSONVeriSeti/master/"
    private let bakimURL = baseURL + "besinler.json"
    
    private init() {}
    
    func getBakim(completed: @escaping (Result<[Bakim], APIError>) -> Void) {
        guard let url = URL(string: bakimURL) else {
            completed(.failure(.invalidURL))
            return
        }
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, response, error in
            guard let _ = error else {
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
                completed(.success(decodedResponse))
            } catch {
                completed(.failure(.invalidData))
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
