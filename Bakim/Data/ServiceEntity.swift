//
//  ServiceEntity.swift
//  Bakim
//
//  Created by Feyzullah Durası on 2.10.2024.
//

import Foundation
import CoreData

struct UserComment: Decodable, Identifiable {
    var id = UUID()
    var username: String
    var rating: Int
    var commentText: String?
}

struct Location: Identifiable, Decodable {
    var id = UUID()
    var latitude: Double?
    var longitude: Double?
    var adress: String
}

struct User: Identifiable, Decodable {
    let id: Int
    let username: String
    let password: String
    let email: String
    let bankcard: BankCard
    let reservations: [Reservation]
}

struct BankCard: Identifiable, Decodable {
    let id: Int
    let cardHolderName: String
    let cardNumber: String
    let cardExpirationDate: CardExpirationDate
    let cardCVC: String
}

struct CardExpirationDate: Decodable {
    let cardExpirationMonth: Int
    let cardExpirationYear: Int
}

struct DailyRevenueItem: Identifiable {
    let id = UUID()
    let date: Date
    let revenue: Double
}

struct Business: Decodable {
    let user: [User]
    let location: [Location]
    let comments: [UserComment]
    let BusinessName: String
    let BusinessImage: String
    let BusinessAddress: String
    let BusinessPhone: String
    let BusinessHours: String
    let BusinessPrice: String
    var services: [Service]
}

enum ServiceType: String, CaseIterable, Decodable {
    case menHairdresser = "mens_hairdresser"
    case womenHairdresser = "womens_hairdresser"
    case petCare = "pet_care"
    case carWash = "car_wash"
    case skinCare = "skin_care"
    case spaMassage = "spa_massage"
    case nailCare = "nail_care"
    case homeCleaner = "home_cleaner"
    case eventSpacesRental = "event_spaces_rental"
    
    var description: String {
        NSLocalizedString(self.rawValue, comment: "")
    }
}
struct Service: Identifiable, Decodable {
    var id: Int
    var serviceType: String
    var serviceFeature: [ServiceFeature]
}

struct ServiceFeature: Identifiable, Hashable, Decodable {
    var id: Int
    var name: String
    var price: Double
    var duration: Int
}
// Sample Features for Each ServiceType


struct Reservation: Identifiable, Decodable {
    var id = UUID()
    var service: Service
    let business: Business
    let date: Date
    let time: String
    let status: ReservationStatus
}

enum ReservationStatus: String, Decodable{
    case pending = "Pending"
    case confirmed = "Confirmed"
    case canceled = "Canceled"
}

enum UserRole: Decodable{
    case user(User)
    case business(Business)
}

struct Bakim: Decodable{
    let user: UserRole
}




struct MockData {
    
    static let sampleUsers: [User] = [
        User(
            id: 101,
            username: "john_doe",
            password: "securepassword",
            email: "john.doe@example.com",
            bankcard: BankCard(
                id: 202,
                cardHolderName: "John Doe",
                cardNumber: "1234567812345678",
                cardExpirationDate: CardExpirationDate(cardExpirationMonth: 12, cardExpirationYear: 2025),
                cardCVC: "123"
            ),
            reservations: []
        )
    ]
    
    static let sampleLocation: Location = Location(
        latitude: 37.7749, // San Francisco latitude
        longitude: -122.4194, // San Francisco longitude
        adress: "San Francisco, CA"
    )
    
    static let sampleComments: [UserComment] = [
        UserComment(username: "sarah_smith", rating: 5, commentText: "Great service!"),
        UserComment(username: "mike_jones", rating: 4, commentText: "Friendly staff and good quality.")
    ]
    
    static let sampleServices: [Service] = [
        Service(
            id: 1, serviceType: "mens_hairdresser",
            serviceFeature: [
                ServiceFeature(id: 101, name: "Haircut", price: 250, duration: 60),
                ServiceFeature(id: 102, name: "Beard Trim", price: 150, duration: 20)
            ]
        ),
        Service(
            id: 4, serviceType: "car_wash",
            serviceFeature: [
                ServiceFeature(id: 401, name: "Exterior Wash", price: 100, duration: 30),
                ServiceFeature(id: 402, name: "Interior Vacuum", price: 150, duration: 30)
            ]
        )
    ]
    
    static let sampleBusiness: Business = Business(
        user: sampleUsers,
        location: [sampleLocation],
        comments: sampleComments,
        BusinessName: "City Salon & Car Wash",
        BusinessImage: "berber",
        BusinessAddress: "123 Main Street, Springfield",
        BusinessPhone: "123-456-7890",
        BusinessHours: "9 AM - 8 PM",
        BusinessPrice: "$$",
        services: sampleServices
    )
    
    static let sampleReservations: [Reservation] = [
        Reservation(
            service: sampleServices[0],  // Men's Hairdresser service
            business: sampleBusiness,
            date: Date(),
            time: "14:00",
            status: .confirmed
        ),
        Reservation(
            service: sampleServices[1],  // Car Wash service
            business: sampleBusiness,
            date: Date().addingTimeInterval(86400),  // One day later
            time: "16:00",
            status: .pending
        )
    ]
    
    static let sampleUsersWithReservations: [User] = [
        User(
            id: 101,
            username: "john_doe",
            password: "securepassword",
            email: "john.doe@example.com",
            bankcard: BankCard(
                id: 202,
                cardHolderName: "John Doe",
                cardNumber: "1234567812345678",
                cardExpirationDate: CardExpirationDate(cardExpirationMonth: 12, cardExpirationYear: 2025),
                cardCVC: "123"
            ),
            reservations: sampleReservations
        )
    ]
    
    static let sampleData: Bakim = Bakim(
        user: .business(
            Business(
                user: sampleUsersWithReservations,
                location: [sampleLocation],
                comments: sampleComments,
                BusinessName: "City Salon & Car Wash",
                BusinessImage: "berber",
                BusinessAddress: "123 Main Street, Springfield",
                BusinessPhone: "123-456-7890",
                BusinessHours: "9 AM - 8 PM",
                BusinessPrice: "$$",
                services: sampleServices
            )
        )
    )
    
}
