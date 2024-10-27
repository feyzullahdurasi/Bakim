//
//  ServiceDetailView.swift
//  Bakim
//
//  Created by Feyzullah Durası on 16.10.2024.
//

import SwiftUI

struct ServiceDetailView: View {
    @StateObject private var viewModel = BarberDetailViewModel()
    @State private var selectedDate = Date()
    @State private var selectedTime = "09:00"
    @State private var selectedServices: Set<String> = []
    @State private var newComment = ""
    @State private var isReservationActive = false
    
    let barberId: Int
    let services = ["Haircut": 100, "Beard Shave": 50, "Hair Dyeing": 200]
    let availableHours = (9...18).map { String(format: "%02d:00", $0) }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                barberInfoSection
                servicesSection
                dateTimeSection
                totalPriceSection
                bookAppointmentButton
                commentsSection
                addCommentSection
                shareButton
            }
            .padding()
        }
        .onAppear {
            viewModel.fetchBarberData(barberId: barberId)
        }
        .alert(isPresented: $viewModel.showAlert) {
            Alert(title: Text("Information"), message: Text(viewModel.alertMessage), dismissButton: .default(Text("Ok")))
        }
        .navigationTitle("Service Details")
        .navigationBarTitleDisplayMode(.inline)
        
        .navigationDestination(isPresented: $isReservationActive) {
            ReservationView(totalPrice: totalPrice, selectedDate: selectedDate, selectedTime: selectedTime)
        }
    }
    
    private var barberInfoSection: some View {
        HStack() {
            if let imageUrl = viewModel.barber?.barberImage {
                AsyncImage(url: URL(string: imageUrl)) { image in
                    image.resizable()
                } placeholder: {
                    Color.gray
                }
                .frame(width: 80, height: 80)
                .clipShape(RoundedRectangle(cornerRadius: 5))
            }
            VStack(alignment: .leading) {
                Text(viewModel.barber?.barberName ?? "")
                    .font(.title)
                Text(viewModel.barber?.localeName ?? "")
                    .font(.subheadline)
            }
        }
    }
    
    private var servicesSection: some View {
        VStack(alignment: .leading) {
            Text("Services")
                .font(.headline)
            ForEach(services.keys.sorted(), id: \.self) { service in
                Toggle(service, isOn: Binding(
                    get: { selectedServices.contains(service) },
                    set: { isSelected in
                        if isSelected {
                            selectedServices.insert(service)
                        } else {
                            selectedServices.remove(service)
                        }
                    }
                ))
            }
        }
    }
    
    private var dateTimeSection: some View {
        VStack(alignment: .leading) {
            DatePicker("Select Date", selection: $selectedDate, in: Date()..., displayedComponents: .date)
            
            Picker("Select Time", selection: $selectedTime) {
                ForEach(availableHours, id: \.self) { hour in
                    Text(hour).tag(hour)
                }
            }
        }
    }
    
    private var totalPriceSection: some View {
        Text("Toplam: \(totalPrice)₺")
            .font(.headline)
    }
    
    private var bookAppointmentButton: some View {
        Button("Make an Appointment") {
            if totalPrice > 0 {
                isReservationActive = true // Trigger navigation to ReservationView
            } else {
                viewModel.alertMessage = "Please select at least one service."
                viewModel.showAlert = true
            }
        }
        .padding()
        .background(Color.blue)
        .foregroundColor(.white)
        .cornerRadius(10)
    }
    
    private var commentsSection: some View {
        VStack(alignment: .leading) {
            Text("Comments")
                .font(.headline)
            ForEach(viewModel.comments, id: \.id) { comment in
                VStack(alignment: .leading) {
                    Text(comment.userName)
                        .font(.subheadline)
                        .fontWeight(.bold)
                    Text(comment.text)
                }
                .padding(.vertical, 5)
            }
        }
    }
    
    private var addCommentSection: some View {
        HStack {
            TextField("Add comment", text: $newComment)
            Button("Add") {
                addComment()
            }
        }
    }
    
    private var shareButton: some View {
        Button("Share") {
            shareBarberDetails()
        }
        .padding()
        .background(Color.green)
        .foregroundColor(.white)
        .cornerRadius(10)
    }
    
    private var totalPrice: Int {
        selectedServices.reduce(0) { $0 + (services[$1] ?? 0) }
    }
    
    private func bookAppointment() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let formattedDate = dateFormatter.string(from: selectedDate)
        
        viewModel.bookAppointment(date: formattedDate, time: selectedTime, services: Array(selectedServices), totalPrice: totalPrice)
    }
    
    private func addComment() {
        guard !newComment.isEmpty else { return }
        viewModel.addComment(Comment(id: UUID(), userName: "New User", text: newComment))
        newComment = ""
    }
    
    private func shareBarberDetails() {
        let shareText = "Hairdresser Details:\nHairdresser: \(viewModel.barber?.barberName ?? "deneme kuafor")\nLocation: \(viewModel.barber?.localeName ?? "")\nTotal Price: \(totalPrice)₺"
        let activityViewController = UIActivityViewController(activityItems: [shareText], applicationActivities: nil)
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first,
           let rootViewController = window.rootViewController {
            rootViewController.present(activityViewController, animated: true, completion: nil)
        }
    }
}

class BarberDetailViewModel: ObservableObject {
    @Published var barber: Barber?
    @Published var comments: [Comment] = []
    @Published var showAlert = false
    @Published var alertMessage = ""
    
    func fetchBarberData(barberId: Int) {
        // API çağrısı simülasyonu
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.barber = Barber(id: barberId, barberName: "John Doe", localeName: "Downtown Salon", barberImage: "https://example.com/image.jpg")
            self.comments = [
                Comment(id: UUID(), userName: "Ahmet", text: "Hizmet mükemmeldi!"),
                Comment(id: UUID(), userName: "Mehmet", text: "Çok memnun kaldım.")
            ]
        }
    }
    
    func bookAppointment(date: String, time: String, services: [String], totalPrice: Int) {
        // API çağrısı simülasyonu
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
        // iOS'ta yerel bildirim planlaması
        let content = UNMutableNotificationContent()
        content.title = "Appointment Reminder"
        content.body = "Your appointment is in 2 hours!"
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm"
        if let appointmentDate = dateFormatter.date(from: "\(date) \(time)") {
            let reminderDate = appointmentDate.addingTimeInterval(-2 * 60 * 60) // 2 saat önce
            let components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: reminderDate)
            let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
            
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
            UNUserNotificationCenter.current().add(request)
        }
    }
}

struct Barber {
    let id: Int
    let barberName: String
    let localeName: String
    let barberImage: String
}

struct Comment: Identifiable {
    let id: UUID
    let userName: String
    let text: String
}


#Preview {
    ServiceDetailView(barberId: 1)
}
