//
//  HomeViewModel.swift
//  Bakim
//
//  Created by Feyzullah Durası on 2.10.2024.
//

import Foundation
import Combine

class HomeViewModel: ObservableObject {
    @Published var currentBusiness: Business?
    @Published var selectedService: Service?
    @Published var isLoading = false
    @Published var hasError = false
    @Published var selectedServiceType: ServiceType?
    @Published var error: APIError?
    
    private var timer: AnyCancellable?
    
    init() {
        setupAutoRefresh()
    }
    
    func refreshData(serviceType: ServiceType? = nil) {
        isLoading = true
        hasError = false
        error = nil
        
        // Simulating network delay with sample data
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            guard let self = self else { return }
            
            // Using MockData for demonstration
            if case .business(let business) = MockData.sampleData.user {
                self.currentBusiness = business
                
                // Filter services if a specific type is selected
                if let selectedType = self.selectedServiceType {
                    let filteredServices = business.services.filter { $0.serviceType == selectedType.rawValue }
                    self.currentBusiness?.services = filteredServices
                }
                
                self.hasError = false
            } else {
                self.hasError = true
                self.error = .invalidData
            }
            
            self.isLoading = false
            self.saveLastRefreshTime()
        }
    }
    
    private func setupAutoRefresh() {
        timer = Timer.publish(every: 300, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                self?.refreshData()
            }
    }
    
    private func saveLastRefreshTime() {
        let currentTime = Date().timeIntervalSince1970
        UserDefaults.standard.set(currentTime, forKey: "lastRefreshTime")
    }
    
    func getLastRefreshTime() -> String {
        let lastRefreshTime = UserDefaults.standard.double(forKey: "lastRefreshTime")
        if lastRefreshTime > 0 {
            let date = Date(timeIntervalSince1970: lastRefreshTime)
            let formatter = DateFormatter()
            formatter.dateFormat = "dd.MM.yyyy HH:mm:ss"
            return "Last update: " + formatter.string(from: date)
        }
        return "No renewal yet"
    }
}
