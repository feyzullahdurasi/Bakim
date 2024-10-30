//
//  ServiceEntity.swift
//  Bakim
//
//  Created by Feyzullah Durası on 2.10.2024.
//

import Foundation
import CoreData


struct ServiceEntity: Identifiable, Codable {
    var id: Int?
    var serviceName: String?
    var localeName: String?
    var carbohydrateContent: String?
    var rating: String?
    var comment: String?
    var serviceImage: String?
    
    init(id: Int?, serviceName: String?, localeName: String?, carbohydrateContent: String?, rating: String?, comment: String?, serviceImage: String?) {
        self.id = id
        self.serviceName = serviceName
        self.localeName = localeName
        self.carbohydrateContent = carbohydrateContent
        self.rating = rating
        self.comment = comment
        self.serviceImage = serviceImage
    }

    enum CodingKeys: String, CodingKey {
        case serviceName = "isim"
        case localeName = "kalori"
        case carbohydrateContent = "karbonhidrat"
        case rating = "protein"
        case comment = "yag"
        case serviceImage = "gorsel"
    }
}

struct UserComment {
    var username: String
    var rating: Int
    var commentText: String?
}

struct Location: Identifiable {
    let id = UUID()
    let latitude: Double
    let longitude: Double
    let adress: String
}

struct User: Identifiable {
    let id: Int
    let username: String
    let password: String
    let email: String
    let bankcard: BankCard
    let reservations: [Reservation]
}

struct BankCard: Identifiable {
    let id: Int
    let cardHolderName: String
    let cardNumber: String
    let cardExpirationDate: CardExpirationDate
    let cardCVC: String
}

struct CardExpirationDate {
    let cardExpirationMonth: Int
    let cardExpirationYear: Int
}

struct Business {
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

enum ServiceType: CustomStringConvertible, CaseIterable {
    case menHairdresser, womenHairdresser, petCare, carWash, skinCare, spaMassage, nailCare

    var description: String {
        switch self {
        case .menHairdresser: return "Men's Hairdresser"
        case .womenHairdresser: return "Women's Hairdresser"
        case .petCare: return "Pet Care"
        case .carWash: return "Car Wash"
        case .skinCare: return "Skin Care"
        case .spaMassage: return "Spa and Massage"
        case .nailCare: return "Nail Care"
        }
    }
}

struct Service {
    var serviceType: ServiceType
    var serviceFeature: [ServiceFeature]
}

struct ServiceFeature: Hashable {
    var name: String
    var price: Int
    var duration: Int
}
// Sample Features for Each ServiceType
let serviceFeatures: [ServiceType: [ServiceFeature]] = [
    .menHairdresser: [
        ServiceFeature(name: "Haircut", price: 20, duration: 30),
        ServiceFeature(name: "Beard Trim", price: 15, duration: 20),
        ServiceFeature(name: "Shampoo", price: 5, duration: 10),
        ServiceFeature(name: "Hair Color", price: 50, duration: 45)
    ],
    .womenHairdresser: [
        ServiceFeature(name: "Haircut", price: 30, duration: 40),
        ServiceFeature(name: "Blow Dry", price: 25, duration: 30),
        ServiceFeature(name: "Hair Color", price: 70, duration: 60),
        ServiceFeature(name: "Deep Conditioning", price: 20, duration: 20)
    ],
    .petCare: [
        ServiceFeature(name: "Pet Grooming", price: 40, duration: 60),
        ServiceFeature(name: "Nail Trimming", price: 10, duration: 15),
        ServiceFeature(name: "Bath", price: 20, duration: 30),
        ServiceFeature(name: "Ear Cleaning", price: 15, duration: 10)
    ],
    .carWash: [
        ServiceFeature(name: "Exterior Wash", price: 10, duration: 15),
        ServiceFeature(name: "Interior Vacuum", price: 15, duration: 20),
        ServiceFeature(name: "Waxing", price: 25, duration: 30),
        ServiceFeature(name: "Engine Clean", price: 30, duration: 45)
    ],
    .skinCare: [
        ServiceFeature(name: "Facial", price: 50, duration: 60),
        ServiceFeature(name: "Exfoliation", price: 30, duration: 45),
        ServiceFeature(name: "Anti-Aging Treatment", price: 70, duration: 60),
        ServiceFeature(name: "Acne Treatment", price: 40, duration: 50)
    ],
    .spaMassage: [
        ServiceFeature(name: "Full Body Massage", price: 60, duration: 60),
        ServiceFeature(name: "Hot Stone Therapy", price: 80, duration: 75),
        ServiceFeature(name: "Aromatherapy", price: 55, duration: 60),
        ServiceFeature(name: "Reflexology", price: 45, duration: 50)
    ],
    .nailCare: [
        ServiceFeature(name: "Manicure", price: 20, duration: 30),
        ServiceFeature(name: "Pedicure", price: 25, duration: 40),
        ServiceFeature(name: "Gel Polish", price: 30, duration: 35),
        ServiceFeature(name: "Nail Art", price: 15, duration: 20)
    ]
]

struct Reservation: Identifiable {
    let id = UUID()
    var service: Service
    let business: Business
    let date: Date
    let time: String
    let status: ReservationStatus
}

enum ReservationStatus: String {
    case pending = "Pending"
    case confirmed = "Confirmed"
    case canceled = "Canceled"
}

enum UserRole {
    case user(User)
    case business(Business)
}

struct Bakim {
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
            latitude: 43.34343,
            longitude: 43.23232,
            adress: "123 Main Street, Springfield"
        )

        static let sampleComments: [UserComment] = [
            UserComment(username: "sarah_smith", rating: 5, commentText: "Great service!"),
            UserComment(username: "mike_jones", rating: 4, commentText: "Friendly staff and good quality.")
        ]

        static let sampleServices: [Service] = [
            Service(
                serviceType: .menHairdresser,
                serviceFeature: [
                    ServiceFeature(name: "Haircut", price: 20, duration: 30),
                    ServiceFeature(name: "Beard Trim", price: 15, duration: 20)
                ]
            ),
            Service(
                serviceType: .carWash,
                serviceFeature: [
                    ServiceFeature(name: "Exterior Wash", price: 10, duration: 15),
                    ServiceFeature(name: "Interior Vacuum", price: 15, duration: 20)
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
