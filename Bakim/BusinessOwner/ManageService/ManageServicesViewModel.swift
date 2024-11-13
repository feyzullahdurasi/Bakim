//
//  ManageServicesViewModel.swift
//  Bakim
//
//  Created by Feyzullah Durası on 12.11.2024.
//

import Foundation

class ManageServicesViewModel: ObservableObject {
    @Published var services: [ServiceEntity] = []

    func addService(_ service: ServiceEntity) {
        services.append(service)
    }
}
