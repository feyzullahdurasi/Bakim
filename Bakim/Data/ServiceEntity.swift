//
//  ServiceEntity.swift
//  Bakim
//
//  Created by Feyzullah Durası on 2.10.2024.
//

import Foundation
import CoreData

// Barber Model with CoreData entity representation
struct ServiceEntity: Identifiable, Codable {
    var id: Int? // Optional UUID if using CoreData or any auto-generation system
    var barberName: String?
    var localeName: String?
    var besinKarbonhidrat: String?
    var rating: String?
    var comment: String?
    var barberImage: String?

    // CodingKeys if JSON keys are different than Swift properties
    enum CodingKeys: String, CodingKey {
        case barberName = "isim"
        case localeName = "kalori"
        case besinKarbonhidrat = "karbonhidrat"
        case rating = "protein"
        case comment = "yag"
        case barberImage = "gorsel"
    }
}

// Comment Model
struct Comment: Identifiable, Codable {
    var id = UUID()  // Unique ID for SwiftUI lists
    var username: String
    var commentText: String
}

