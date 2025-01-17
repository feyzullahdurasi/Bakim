//
//  ServiceDetailViewModel.swift
//  Bakim
//
//  Created by Feyzullah Durası on 16.10.2024.
//

import Foundation
import Combine
import UserNotifications

@MainActor
class ServiceDetailViewModel: ObservableObject {
    @Published private(set) var service: Service
    @Published private(set) var business: Business
    @Published var showAlert = false
    @Published var alertMessage = ""
    @Published private(set) var isLoading = false
    @Published var error: Error?
    
    private let repository: ServiceRepositoryProtocol
    
    init(
        service: Service,
        business: Business,
        repository: ServiceRepositoryProtocol = ServiceRepository()
    ) {
        self.service = service
        self.business = business
        self.repository = repository
    }
    
    func makeReservation(date: Date, time: String, features: Set<ServiceFeature>) async {
        isLoading = true
        do {
            let reservation = try await repository.createReservation(
                serviceFeatures: features,
                date: date,
                time: time
            )
            
            await scheduleReminder(for: reservation)
            showAlert(message: "Rezervasyon başarıyla oluşturuldu!")
            
            // Backend'den yeni service detaylarını al
            service = try await repository.getServiceDetails(serviceId: service.id)
            
        } catch let error as APIError {
            showAlert(message: error.errorMessage)
        } catch {
            showAlert(message: "Beklenmeyen bir hata oluştu")
        }
        isLoading = false
    }
    
    func addUserComment(_ comment: String, rating: Int = 5) async {
        isLoading = true
        do {
            let newComment = try await repository.addComment(
                serviceId: service.id,
                comment: comment,
                rating: rating
            )
            
            // Yorumları güncelle
            service = try await repository.getServiceDetails(serviceId: service.id)
            showAlert(message: "Yorum başarıyla eklendi!")
        } catch {
            showAlert(message: "Yorum eklenirken hata oluştu: \(error.localizedDescription)")
        }
        isLoading = false
    }
    
    func showAlert(message: String) {
        self.alertMessage = message
        self.showAlert = true
    }
    
    func scheduleReminder(for reservation: Reservation) async {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd" // Reservation.date formatına uygun format
        
        guard let reservationDate = formatter.date(from: reservation.date) else {
            print("Invalid date format for reservation: \(reservation.date)")
            return
        }
        
        // `reservationDate` artık bir `Date` türünde
        print("Reminder scheduled for \(reservationDate)")
    }

}
