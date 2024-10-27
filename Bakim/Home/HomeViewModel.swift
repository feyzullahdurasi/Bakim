//
//  HomeViewModel.swift
//  Bakim
//
//  Created by Feyzullah Durası on 2.10.2024.
//

import Foundation
import Combine

class HomeViewModel: ObservableObject {
    @Published var services: [ServiceEntity] = []
    @Published var serviceLoading: Bool = false
    @Published var serviceError: Bool = false
    @Published var selectedServiceType: String?

    private let apiService = APIService()
    private var cancellables = Set<AnyCancellable>()

    init() {
        setupTimerForRefresh()
    }

    func refreshData(serviceType: String?) {
        serviceLoading = true
        serviceError = false
        selectedServiceType = serviceType

        apiService.fetchServices { [weak self] fetchedServices in
            DispatchQueue.main.async {
                self?.serviceLoading = false
                if let services = fetchedServices {
                    if let serviceType = serviceType {
                        self?.services = services.filter { $0.serviceName == serviceType }
                    } else {
                        self?.services = services
                    }
                    self?.saveLastRefreshTime()
                } else {
                    self?.serviceError = true
                }
            }
        }
    }

    private func setupTimerForRefresh() {
        Timer.publish(every: 300, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                self?.refreshData(serviceType: self?.selectedServiceType)
            }
            .store(in: &cancellables)
    }

    private func saveLastRefreshTime() {
        let currentTime = Date().timeIntervalSince1970
        PSharedPreferences.shared.saveTime(currentTime)
    }

    func getLastRefreshTime() -> String {
        guard let lastRefreshTime = PSharedPreferences.shared.getTime() else {
            return "No renewal yet"
        }
        let date = Date(timeIntervalSince1970: lastRefreshTime)
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy HH:mm:ss"
        return "Last update: " + formatter.string(from: date)
    }
}
