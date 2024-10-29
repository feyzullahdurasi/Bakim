//
//  ServiceDetailViewModel.swift
//  Bakim
//
//  Created by Feyzullah Durası on 16.10.2024.
//

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
    @Published var service: ServiceEntity?
    @Published var userComments: [UserComment] = []
    @Published var showAlert = false
    @Published var alertMessage = ""
    
    private let apiService = APIService()
    private var cancellables = Set<AnyCancellable>()
    
    func fetchServiceData(serviceId: Int) {
        // Simulating an API call
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.service = ServiceEntity(
                id: serviceId,
                serviceName: "Example Service",
                localeName: "Tuzla Merkez",
                carbohydrateContent: "10g",
                rating: "4.5",
                comment: "Excellent service!",
                serviceImage: "https://example.com/image.jpg"
            )
            
            self.userComments = [
                UserComment(username: "Ahmet", commentText: "Hizmet mükemmeldi!"),
                UserComment(username: "Mehmet", commentText: "Çok memnun kaldım.")
            ]
        }
    }
    
    func bookAppointment(date: String, time: String, services: [String], totalPrice: Int) {
        // Simulating an API call
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.showAlert = true
            self.alertMessage = "Randevu alındı: \(date) - \(time) - \(services.joined(separator: ", ")) (\(totalPrice)₺)"
            self.scheduleReminder(date: date, time: time)
        }
    }
    
    func addUserComment(_ comment: UserComment) {
        userComments.append(comment)
    }
    
    private func scheduleReminder(date: String, time: String) {
        let content = UNMutableNotificationContent()
        content.title = "Appointment Reminder"
        content.body = "Your appointment is in 2 hours!"
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm"
        if let appointmentDate = dateFormatter.date(from: "\(date) \(time)") {
            let reminderDate = appointmentDate.addingTimeInterval(-2 * 60 * 60) // 2 hours earlier
            let components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: reminderDate)
            let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
            
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
            UNUserNotificationCenter.current().add(request)
        }
    }
}
