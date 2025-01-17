//
//  ServiceRepository.swift
//  Bakim
//
//  Created by Feyzullah Durası on 13.01.2025.
//

import Foundation

protocol ServiceRepositoryProtocol {
    func getServiceDetails(serviceId: Int) async throws -> Service
    func createReservation(serviceFeatures: Set<ServiceFeature>, date: Date, time: String) async throws -> Reservation
    func addComment(serviceId: Int, comment: String, rating: Int) async throws -> UserComment
}

class ServiceRepository: ServiceRepositoryProtocol {
    private let networkService: NetworkService
    
    init(networkService: NetworkService = .shared) {
        self.networkService = networkService
    }
    
    func getServiceDetails(serviceId: Int) async throws -> Service {
        return try await networkService.request(
            endpoint: "/services/\(serviceId)"
        )
    }
    
    func createReservation(serviceFeatures: Set<ServiceFeature>, date: Date, time: String) async throws -> Reservation {
        let request = ReservationRequest(
            serviceFeatureIds: Array(serviceFeatures).map { $0.id },
            date: date.formatted(.iso8601),
            time: time,
            userId: UserDefaults.standard.integer(forKey: "userId")
        )
        
        return try await networkService.request(
            endpoint: "/reservations",
            method: "POST",
            body: try JSONEncoder().encode(request)
        )
    }
    
    func addComment(serviceId: Int, comment: String, rating: Int) async throws -> UserComment {
        let request = CommentRequest(
            comment: comment,
            rating: rating,
            userId: UserDefaults.standard.integer(forKey: "userId")
        )
        
        return try await networkService.request(
            endpoint: "/services/\(serviceId)/comments",
            method: "POST",
            body: try JSONEncoder().encode(request)
        )
    }
}
