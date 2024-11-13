//
//  ManageServicesViewModel.swift
//  Bakim
//
//  Created by Feyzullah Durası on 12.11.2024.
//

import Foundation

class ManageServicesViewModel: ObservableObject {
    @Published var services: [Service] = []

    func loadServices() {
        services = ManageServicesViewModel.sampleServices
    }

    func addService(_ service: Service) {
        services.append(service)
    }

    func deleteService(_ service: Service) {
        services.removeAll { $0.serviceType == service.serviceType }
    }

    static let sampleServices: [Service] = [
        Service(
            serviceType: .menHairdresser,
            serviceFeature: [
                ServiceFeature(name: "Haircut", price: 250, duration: 60),
                ServiceFeature(name: "Beard Trim", price: 150, duration: 20)
            ]
        ),
        Service(
            serviceType: .carWash,
            serviceFeature: [
                ServiceFeature(name: "Exterior Wash", price: 100, duration: 30),
                ServiceFeature(name: "Interior Vacuum", price: 150, duration: 30)
            ]
        )
    ]
}
