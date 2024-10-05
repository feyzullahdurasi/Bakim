//
//  ServiceEntity.swift
//  Bakim
//
//  Created by Feyzullah Durası on 2.10.2024.
//

import Foundation
import CoreData

struct ServiceEntity: Identifiable, Codable {
    var id: Int?  // Optional UUID if using CoreData or any auto-generation system
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

    // CodingKeys if JSON keys are different from Swift properties
    enum CodingKeys: String, CodingKey {
        case serviceName = "isim"
        case localeName = "kalori"
        case carbohydrateContent = "karbonhidrat"
        case rating = "protein"
        case comment = "yag"
        case serviceImage = "gorsel"
    }
}

// Comment Model for user feedback
struct UserComment: Identifiable, Codable {
    var id = UUID()  // Unique ID for SwiftUI lists
    var username: String
    var commentText: String
}

