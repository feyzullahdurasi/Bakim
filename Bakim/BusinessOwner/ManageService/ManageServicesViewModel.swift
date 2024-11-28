//
//  ManageServicesViewModel.swift
//  Bakim
//
//  Created by Feyzullah Durası on 12.11.2024.
//

import Foundation

class ManageServicesViewModel: ObservableObject {
    @Published var services: [Service] = []
    @Published var errorMessage: String?

    func loadServices() {
        NetworkService.shared.getBakim { result in
            switch result {
            case .success(let bakimList):
                print("Başarıyla yüklendi: \(bakimList)")
            case .failure(let error):
                print("Hata oluştu: \(error.localizedDescription)")
            }
        }
    }

    func addService(_ service: Service) {
        services.append(service)
    }

    func deleteService(_ service: Service) {
        services.removeAll { $0.serviceType == service.serviceType }
    }
}
