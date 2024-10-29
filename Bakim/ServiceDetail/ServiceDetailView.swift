//
//  ServiceDetailView.swift
//  Bakim
//
//  Created by Feyzullah Durası on 16.10.2024.
//

import SwiftUI
import MapKit

struct ServiceDetailView: View {
    @StateObject private var viewModel = ServiceDetailViewModel()
    @State private var selectedDate = Date()
    @State private var selectedTime = "09:00"
    @State private var selectedServices: Set<String> = []
    @State private var newComment = ""
    @State private var isReservationActive = false
    
    let serviceId: Int
    let services: [String: Int] = ["Haircut": 100, "Beard Shave": 50, "Hair Dyeing": 200]
    let availableHours = (9...18).map { String(format: "%02d:00", $0) }
    
    var body: some View {
        VStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    serviceInfoSection
                    servicesSection
                    dateTimeSection
                    locationSection
                    commentsSection
                    addCommentSection
                }
                .padding()
            }
            .onAppear {
                viewModel.fetchServiceData(serviceId: serviceId)
            }
            .alert(isPresented: $viewModel.showAlert) {
                Alert(title: Text("Information"), message: Text(viewModel.alertMessage), dismissButton: .default(Text("Ok")))
            }
            .navigationTitle("Service Details")
            .navigationBarTitleDisplayMode(.inline)
            
            .navigationDestination(isPresented: $isReservationActive) {
                ReservationView(totalPrice: totalPrice, selectedDate: selectedDate, selectedTime: selectedTime)
            }
            Spacer()
            Divider()
            HStack {
                totalPriceSection
                Spacer()
                bookAppointmentButton
            }
            .padding(.horizontal)
            .padding(.bottom)
        }
    }
    
    private var serviceInfoSection: some View {
        VStack() {
            if let imageUrl = viewModel.service?.serviceImage {
                AsyncImage(url: URL(string: imageUrl)) { image in
                    image.resizable()
                } placeholder: {
                    Color.gray
                }
                .frame(height: 200)
                .clipShape(RoundedRectangle(cornerRadius: 5))
            }
            HStack {
                VStack(alignment: .leading) {
                    Text(viewModel.service?.serviceName ?? "")
                        .font(.title)
                    Text(viewModel.service?.localeName ?? "")
                        .font(.subheadline)
                }
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
    
    // 40.869497, 29.328127
    private var locationSection: some View {
        VStack(alignment: .leading) {
            Text("Location")
                .font(.headline)
            
            
            let location = Location(latitude: 40.869497, longitude: 29.328127, name: "Barber Shop")
            
            Map(coordinateRegion: .constant(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude), span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))), interactionModes: [])
                .frame(height: 200)
                .cornerRadius(10)
            
            Text(location.name)
                .font(.subheadline)
                .padding(.top, 5)
        }
    }
    
    private var commentsSection: some View {
        VStack(alignment: .leading) {
            Text("Comments")
                .font(.headline)
            ForEach(viewModel.userComments, id: \.id) { comment in
                VStack(alignment: .leading) {
                    Text(comment.username)
                        .font(.subheadline)
                        .fontWeight(.bold)
                    Text(comment.commentText)
                }
                .padding(.vertical, 5)
            }
        }
    }
    
    private var addCommentSection: some View {
        HStack {
            TextField("Add comment", text: $newComment)
            Button("Add") {
                addUserComment()
            }
        }
    }
    
    private var totalPriceSection: some View {
        Text("Total: \(totalPrice)₺")
            .font(.headline)
    }
    
    private var bookAppointmentButton: some View {
        Button("Make an Appointment") {
            if totalPrice > 0 {
                isReservationActive = true
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
    
    private var totalPrice: Int {
        selectedServices.reduce(0) { $0 + (services[$1] ?? 0) }
    }
    
    private func bookAppointment() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let formattedDate = dateFormatter.string(from: selectedDate)
        
        viewModel.bookAppointment(date: formattedDate, time: selectedTime, services: Array(selectedServices), totalPrice: totalPrice)
    }
    
    private func addUserComment() {
        guard !newComment.isEmpty else { return }
        viewModel.addUserComment(UserComment(username: "New User", commentText: newComment))
        newComment = ""
    }
}

#Preview {
    ServiceDetailView(serviceId: 1)
}
