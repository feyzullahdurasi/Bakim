//
//  HomeViewModel.swift
//  Bakim
//
//  Created by Feyzullah Durası on 2.10.2024.
//

import Foundation
import Combine

@MainActor
class HomeViewModel: ObservableObject {
    @Published private(set) var currentBusiness: Business?
    @Published private(set) var selectedServiceType: ServiceType?
    @Published private(set) var isLoading = false
    @Published var hasError = false
    @Published var error: APIError?
    @Published var filteredServices: [Service] = []
    
    private let networkService: NetworkService
    private var refreshTimer: Timer?
    
    init(networkService: NetworkService = .shared, selectedServiceType: ServiceType? = nil) {
        self.networkService = networkService
        self.selectedServiceType = selectedServiceType
        setupAutoRefresh()
    }
    
    func refreshData() async {
        isLoading = true
        hasError = false
        error = nil
        
        do {
            let services = try await networkService.request(
                endpoint: "/services",
                method: "GET"
            ) as [Service]
            
            if let selectedType = selectedServiceType {
                filteredServices = services.filter { $0.serviceType.id == selectedType.id }
            } else {
                filteredServices = services
            }
            
        } catch {
            self.error = error as? APIError ?? .unableToComplete
            hasError = true
        }
        
        isLoading = false
    }
    
    func searchServices(query: String) async {
        guard !query.isEmpty else {
            await refreshData()
            return
        }
        
        isLoading = true
        do {
            filteredServices = try await networkService.request(
                endpoint: "/services/search?q=\(query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")",
                method: "GET"
            )
        } catch {
            self.error = error as? APIError ?? .unableToComplete
            hasError = true
        }
        isLoading = false
    }
    
    func applyFilters(minPrice: Double?, maxPrice: Double?, location: String?) async {
        isLoading = true
        
        var queryItems: [URLQueryItem] = []
        if let minPrice = minPrice {
            queryItems.append(URLQueryItem(name: "minPrice", value: String(minPrice)))
        }
        if let maxPrice = maxPrice {
            queryItems.append(URLQueryItem(name: "maxPrice", value: String(maxPrice)))
        }
        if let location = location {
            queryItems.append(URLQueryItem(name: "location", value: location))
        }
        
        var endpoint = "/services/filter"
        if !queryItems.isEmpty {
            var components = URLComponents(string: endpoint)!
            components.queryItems = queryItems
            endpoint = components.url?.absoluteString ?? endpoint
        }
        
        do {
            filteredServices = try await networkService.request(
                endpoint: endpoint,
                method: "GET"
            )
        } catch {
            self.error = error as? APIError ?? .unableToComplete
            hasError = true
        }
        
        isLoading = false
    }
    
    private func setupAutoRefresh() {
        refreshTimer = Timer.scheduledTimer(withTimeInterval: 300, repeats: true) { [weak self] _ in
            Task { [weak self] in
                await self?.refreshData()
            }
        }
    }
    
    deinit {
        refreshTimer?.invalidate()
    }
    
    func getLastRefreshTime() -> String {
        let lastRefreshTime = UserDefaults.standard.double(forKey: "lastRefreshTime")
        if (lastRefreshTime > 0) {
            let date = Date(timeIntervalSince1970: lastRefreshTime)
            let formatter = DateFormatter()
            formatter.dateFormat = "dd.MM.yyyy HH:mm:ss"
            return "Last update: " + formatter.string(from: date)
        }
        return "No renewal yet"
    }
}
