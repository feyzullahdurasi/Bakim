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

struct UserComment: Identifiable, Codable {
    var id = UUID()
    var username: String
    var commentText: String
}

