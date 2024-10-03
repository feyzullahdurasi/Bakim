//
//  HomeViewModel.swift
//  Bakim
//
//  Created by Feyzullah Durası on 2.10.2024.
//

import Foundation
import SwiftUI
import Combine

// ViewModel class equivalent to HomeViewModel in Android
class HomeViewModel: ObservableObject {
    @Published var services: [ServiceEntity] = []
    @Published var serviceError: Bool = false
    @Published var serviceLoading: Bool = false
    
    private var updateTime: TimeInterval = 10 * 60 // 10 minutes
    private let apiService = ServiceAPIService()
    private let preferences = PSharedPreferences()
    
    // Refresh data, checks if the data is stale and decides between fetching from SQLite or the internet
    func refreshData(serviceType: String?) {
        let currentTime = Date().timeIntervalSince1970
        if let savedTime = preferences.getTime(), currentTime - savedTime < updateTime {
            // Fetch data from SQLite
            getDataFromSQLite()
        } else {
            // Fetch data from the internet
            getDataFromInternet()
        }
    }
    
    // Force refresh from internet
    func refreshDataFromInternet(serviceType: String?) {
        getDataFromInternet()
    }
    
    // Fetch data from SQLite (using CoreData or other storage method)
    private func getDataFromSQLite() {
        self.serviceLoading = true
        DispatchQueue.global(qos: .background).async {
            // Simulate fetching data from SQLite or CoreData
            let servicesList = ServiceDatabase.shared.getAllServices()
            DispatchQueue.main.async {
                self.showServices(servicesList)
                print("Veriler Room'dan alındı")
            }
        }
    }
    
    // Fetch data from the internet
    private func getDataFromInternet() {
        self.serviceLoading = true
        Task {
            do {
                let servicesList = try await apiService.getData()
                if !servicesList.isEmpty {
                    self.getDataFromRoom(servicesList)
                    print("Veriler Internet'ten alındı")
                } else {
                    self.serviceError = true
                    self.serviceLoading = false
                }
            } catch {
                self.serviceError = true
                self.serviceLoading = false
                print("Bir hata oluştu: \(error.localizedDescription)")
            }
        }
    }
    
    // Show services on UI
    private func showServices(_ serviceList: [ServiceEntity]) {
        DispatchQueue.main.async {
            self.services = serviceList
            self.serviceError = false
            self.serviceLoading = false
        }
    }
    
    // Save data to local storage (SQLite or CoreData)
    private func getDataFromRoom(_ serviceList: [ServiceEntity]) {
        DispatchQueue.global(qos: .background).async {
            ServiceDatabase.shared.deleteAllServices()
            let insertedServiceIds = ServiceDatabase.shared.insertAll(services: serviceList)
            
            // Update UUIDs (if needed)
            for i in 0..<serviceList.count {
                serviceList[i].uuid = insertedServiceIds[i]
            }
            
            DispatchQueue.main.async {
                self.showServices(serviceList)
            }
            
            self.preferences.saveTime(Date().timeIntervalSince1970)
        }
    }
}

// Mock API service
class ServiceAPIService {
    func getData() async throws -> [ServiceEntity] {
        // Simulate network call
        await Task.sleep(1 * 1_000_000_000) // 1 second delay
        if Bool.random() {
            return [ServiceEntity(uuid: 1, name: "Selim Serdar Kuaför", location: "Aydınlı Mah. Merkez", rating: 4.5),
                    ServiceEntity(uuid: 2, name: "Osman Usta Kuaför", location: "Pendik Merkez", rating: 4.8)]
        } else {
            throw URLError(.badServerResponse)
        }
    }
}

// Mock Local Storage (CoreData / SQLite)
class ServiceDatabase {
    static let shared = ServiceDatabase()
    
    private init() {}
    
    func getAllServices() -> [ServiceEntity] {
        // Simulate SQLite or CoreData fetching
        return [ServiceEntity(uuid: 1, name: "John Doe", location: "Downtown", rating: 4.3)]
    }
    
    func insertAll(services: [ServiceEntity]) -> [Int] {
        // Simulate inserting into SQLite or CoreData and returning UUIDs
        return Array(1...services.count)
    }
    
    func deleteAllServices() {
        // Simulate deletion from SQLite or CoreData
    }
}

// Preferences for storing last refresh time
class PSharedPreferences {
    private let lastSavedTimeKey = "lastSavedTime"
    
    func getTime() -> TimeInterval? {
        return UserDefaults.standard.double(forKey: lastSavedTimeKey)
    }
    
    func saveTime(_ time: TimeInterval) {
        UserDefaults.standard.set(time, forKey: lastSavedTimeKey)
    }
}

// ServiceEntity Model
struct ServiceEntity: Identifiable {
    var id: Int { uuid }
    var uuid: Int
    var name: String
    var location: String
    var rating: Double
}

