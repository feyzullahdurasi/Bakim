//
//  APIService.swift
//  Bakim
//
//  Created by Feyzullah Durası on 3.10.2024.
//

import Foundation

// Central API service for handling network requests
class APIService {
    static let shared = APIService()

    // Fetch JSON data from a given URL
    func fetchJSON<T: Decodable>(from urlString: String, dateDecodingStrategy: JSONDecoder.DateDecodingStrategy = .deferredToDate) async throws -> T {
        guard let url = URL(string: urlString) else {
            throw APIError.invalidURL
        }

        do {
            let (data, response) = try await URLSession.shared.data(from: url)

            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                throw APIError.invalidResponse(statusCode: (response as? HTTPURLResponse)?.statusCode ?? -1)
            }

            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = dateDecodingStrategy
            return try decoder.decode(T.self, from: data)
        } catch {
            throw APIError.networkError(error)
        }
    }

    enum APIError: Error {
        case invalidURL
        case invalidResponse(statusCode: Int)
        case networkError(Error)

        var userErrorMessage: String {
            switch self {
            case .invalidURL:
                return "Geçersiz bir URL ile karşılaşıldı. Lütfen URL'yi kontrol edin."
            case .invalidResponse(let statusCode):
                return "Sunucu yanıtında bir hata oluştu. Durum kodu: \(statusCode)."
            case .networkError(let error):
                return "Ağ bağlantısı sırasında bir hata oluştu: \(error.localizedDescription)."
            }
        }
    }
}

// Service API for fetching service entities
class ServiceAPI {
    private let baseURL = "https://raw.githubusercontent.com/"

    // Fetch service entities from the API
    func fetchServices() async throws -> [ServiceEntity] {
        let urlString = "\(baseURL)atilsamancioglu/BTK20-JSONVeriSeti/master/besinler.json"
        return try await APIService.shared.fetchJSON(from: urlString)
    }
}

// Example usage of the ServiceAPI
// This can be placed in your ViewModel or wherever you need to call the API
func fetchServicesExample() {
    let serviceAPI = ServiceAPI()
    Task {
        do {
            let services = try await serviceAPI.fetchServices()
            print("Fetched services: \(services)")
        } catch let error as APIService.APIError {
            print("Error fetching services: \(error.userErrorMessage)")
        } catch {
            print("An unexpected error occurred: \(error.localizedDescription)")
        }
    }
}
