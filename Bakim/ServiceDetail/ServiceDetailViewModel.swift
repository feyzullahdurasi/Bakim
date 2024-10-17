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
    @Published var barber: Barber?
    @Published var comments: [Comment] = []
    @Published var showAlert = false
    @Published var alertMessage = ""
    
    private let apiService = APIService()
    private var cancellables = Set<AnyCancellable>()
    
    func fetchBarberData(barberId: Int) {
        // Simulating an API call
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.barber = Barber(id: barberId, barberName: "Ornek Kuafor", localeName: "Tuzla Merkez", barberImage: "https://example.com/image.jpg")
            self.comments = [
                Comment(id: UUID(), userName: "Ahmet", text: "Hizmet mükemmeldi!"),
                Comment(id: UUID(), userName: "Mehmet", text: "Çok memnun kaldım.")
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
    
    func addComment(_ comment: Comment) {
        comments.append(comment)
    }
    
    private func scheduleReminder(date: String, time: String) {
        let content = UNMutableNotificationContent()
        content.title = "Randevu Hatırlatıcı"
        content.body = "Randevunuz 2 saat içinde!"
        
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

