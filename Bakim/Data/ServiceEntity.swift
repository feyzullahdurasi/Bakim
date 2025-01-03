//
//  ServiceEntity.swift
//  Bakim
//
//  Created by Feyzullah Durası on 2.10.2024.
//

import Foundation

// MARK: - Base Models

struct User: Identifiable, Codable {
    let id: Int
    let username: String
    let email: String
    var bankCards: [BankCard]?
    var reservations: [Reservation]?
    
    enum CodingKeys: String, CodingKey {
        case id = "UserID"
        case username = "Username"
        case email = "Email"
        case bankCards
        case reservations
    }
}

struct BankCard: Identifiable, Codable {
    let id: Int
    let cardHolderName: String
    let cardNumber: String
    let cardExpirationMonth: Int
    let cardExpirationYear: Int
    let cardCVC: String
    
    enum CodingKeys: String, CodingKey {
        case id = "CardID"
        case cardHolderName = "CardHolderName"
        case cardNumber = "CardNumber"
        case cardExpirationMonth = "CardExpirationMonth"
        case cardExpirationYear = "CardExpirationYear"
        case cardCVC = "CardCVC"
    }
}

struct Location: Identifiable, Codable {
    let id: Int
    let latitude: Double?
    let longitude: Double?
    let address: String
    
    enum CodingKeys: String, CodingKey {
        case id = "LocationID"
        case latitude = "Latitude"
        case longitude = "Longitude"
        case address = "Address"
    }
}

struct Business: Identifiable, Codable {
    let id: Int
    let name: String
    let image: String?
    let address: String
    let phone: String
    let hours: String
    let price: String
    let location: Location?
    var serviceTypes: [ServiceType]?
    var reservations: [Reservation]?
    
    enum CodingKeys: String, CodingKey {
        case id = "BusinessID"
        case name = "BusinessName"
        case image = "BusinessImage"
        case address = "BusinessAddress"
        case phone = "BusinessPhone"
        case hours = "BusinessHours"
        case price = "BusinessPrice"
        case location
        case serviceTypes
        case reservations
    }
}

struct ServiceType: Identifiable, Codable {
    let id: Int
    let name: String
    let description: String?
    var features: [ServiceFeature]?
    
    enum CodingKeys: String, CodingKey {
        case id = "ServiceTypeID"
        case name = "ServiceTypeName"
        case description = "ServiceTypeDescription"
        case features
    }
}

struct ServiceFeature: Identifiable, Codable, Hashable {
    let id: Int
    let name: String
    let price: Decimal
    let duration: Int
    
    enum CodingKeys: String, CodingKey {
        case id = "FeatureID"
        case name = "FeatureName"
        case price = "Price"
        case duration = "Duration"
    }
    
    // Hashable implementation
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: ServiceFeature, rhs: ServiceFeature) -> Bool {
        lhs.id == rhs.id
    }
}

struct Reservation: Identifiable, Codable {
    let id: String // UUID in backend
    let date: String // YYYY-MM-DD format
    let time: String // HH:mm:ss format
    let status: ReservationStatus
    let createdAt: Date
    var user: User?
    var business: Business?
    var serviceFeature: ServiceFeature?
    
    enum CodingKeys: String, CodingKey {
        case id = "ReservationID"
        case date = "ReservationDate"
        case time = "ReservationTime"
        case status = "Status"
        case createdAt = "CreatedAt"
        case user
        case business
        case serviceFeature
    }
}

// MARK: - Enums

enum ReservationStatus: String, Codable {
    case pending = "Pending"
    case confirmed = "Confirmed"
    case canceled = "Canceled"
}

// MARK: - Additional Models (If needed for your app's functionality)

struct UserComment: Identifiable, Codable {
    let id: UUID
    let username: String
    let rating: Int
    let commentText: String?
}

struct DailyRevenueItem: Identifiable {
    let id = UUID()
    let date: Date
    let revenue: Double
}
