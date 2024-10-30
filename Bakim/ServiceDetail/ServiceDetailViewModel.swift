//
//  ServiceDetailViewModel.swift
//  Bakim
//
//  Created by Feyzullah Durası on 16.10.2024.
//

import Foundation
import Combine
import UserNotifications

class ServiceDetailViewModel: ObservableObject {
    @Published private(set) var service: Service
    @Published private(set) var business: Business
    @Published var showAlert = false
    @Published var alertMessage = ""
    
    init(service: Service, business: Business) {
        self.service = service
        self.business = business
    }
    
    func addUserComment(_ comment: String) {
        _ = UserComment(
            username: "Current User", // In real app, get from user session
            rating: 5, // Add UI for rating selection
            commentText: comment
        )
        
        // In real app, send to backend
        // For now, just update local state
        
    }
    
    func makeReservation(date: Date, time: String, features: Set<ServiceFeature>) {
        let reservation = Reservation(
            service: service,
            business: business,
            date: date,
            time: time,
            status: .pending
        )
        
        // In real app, send to backend
        scheduleReminder(for: reservation)
        showAlert(message: "Reservation request sent successfully!")
    }
    
    func showAlert(message: String) {
        alertMessage = message
        showAlert = true
    }
    
    private func scheduleReminder(for reservation: Reservation) {
        let content = UNMutableNotificationContent()
        content.title = "Appointment Reminder"
        content.body = "Your appointment at \(business.BusinessName) is in 2 hours!"
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        
        if let appointmentTime = dateFormatter.date(from: reservation.time) {
            let calendar = Calendar.current
            var components = calendar.dateComponents([.year, .month, .day], from: reservation.date)
            let timeComponents = calendar.dateComponents([.hour, .minute], from: appointmentTime)
            
            components.hour = timeComponents.hour
            components.minute = timeComponents.minute
            
            if let finalDate = calendar.date(from: components) {
                let reminderDate = finalDate.addingTimeInterval(-2 * 3600) // 2 hours before
                let reminderComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: reminderDate)
                let trigger = UNCalendarNotificationTrigger(dateMatching: reminderComponents, repeats: false)
                
                let request = UNNotificationRequest(
                    identifier: UUID().uuidString,
                    content: content,
                    trigger: trigger
                )
                
                UNUserNotificationCenter.current().add(request)
            }
        }
    }
}
