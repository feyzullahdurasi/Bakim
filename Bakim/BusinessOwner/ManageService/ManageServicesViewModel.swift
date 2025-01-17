//
//  ManageServicesViewModel.swift
//  Bakim
//
//  Created by Feyzullah Durası on 12.11.2024.
//

import Foundation

@MainActor
class ManageServicesViewModel: ObservableObject {
    @Published var services: [Service] = []
    @Published var isLoading = false
    @Published var error: APIError?
    @Published var showError = false
    
    private let businessId: Int
    private let networkService: NetworkService
    
    init(businessId: Int = UserDefaults.standard.integer(forKey: "businessId"),
         networkService: NetworkService = .shared) {
        self.businessId = businessId
        self.networkService = networkService
    }
    
    func loadServices() async {
        isLoading = true
        do {
            services = try await networkService.getBusinessServices(businessId: businessId)
        } catch let error as APIError {
            self.error = error
            showError = true
        } catch {
            self.error = .unableToComplete
            showError = true
        }
        isLoading = false
    }
    
    func addService(_ service: Service) async {
        isLoading = true
        do {
            let newService = try await networkService.createService(service)
            services.append(newService)
        } catch let error as APIError {
            self.error = error
            showError = true
        } catch {
            self.error = .unableToComplete
            showError = true
        }
        isLoading = false
    }
    
    func updateService(_ service: Service) async {
        isLoading = true
        do {
            let updatedService = try await networkService.updateService(service)
            if let index = services.firstIndex(where: { $0.id == service.id }) {
                services[index] = updatedService
            }
        } catch let error as APIError {
            self.error = error
            showError = true
        } catch {
            self.error = .unableToComplete
            showError = true
        }
        isLoading = false
    }
    
    func deleteService(_ service: Service) async {
        isLoading = true
        do {
            try await networkService.deleteService(serviceId: service.id)
            services.removeAll { $0.id == service.id }
        } catch let error as APIError {
            self.error = error
            showError = true
        } catch {
            self.error = .unableToComplete
            showError = true
        }
        isLoading = false
    }
}
