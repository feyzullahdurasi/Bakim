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
        let newComment = UserComment(
            username: "Current User",
            rating: 5,
            commentText: comment
        )
        //business.comments.append(newComment)
        showAlert(message: "Comment added successfully!")
    }
    
    func makeReservation(date: Date, time: String, features: Set<ServiceFeature>) {
        let reservation = Reservation(
            service: service,
            business: business,
            date: date,
            time: time,
            status: .pending
        )
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
        
        let calendar = Calendar.current
        let finalDate = calendar.date(bySettingHour: Int(reservation.time.prefix(2))!,
                                      minute: 0, second: 0, of: reservation.date)
        let reminderDate = finalDate?.addingTimeInterval(-2 * 3600) // 2 hours before
        
        if let reminderDate = reminderDate {
            let reminderComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: reminderDate)
            let trigger = UNCalendarNotificationTrigger(dateMatching: reminderComponents, repeats: false)
            
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
            UNUserNotificationCenter.current().add(request)
        }
    }
}
