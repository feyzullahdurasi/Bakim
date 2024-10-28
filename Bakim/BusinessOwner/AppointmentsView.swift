//
//  AppointmentsView.swift
//  Bakim
//
//  Created by Feyzullah Durası on 28.10.2024.
//

import SwiftUI

// Sample Appointment model
struct Appointment: Identifiable {
    let id: UUID
    let customerName: String
    let serviceType: String
    let time: Date
    let status: String
}

// Sample ViewModel for fetching appointments
class AppointmentsViewModel: ObservableObject {
    @Published var appointments: [Appointment] = []
    @Published var selectedDate: Date
    
    init(selectedDate: Date) {
        self.selectedDate = selectedDate
        loadAppointments(for: selectedDate)
    }
    
    // Function to load appointments based on selected date
    func loadAppointments(for date: Date) {
        // Replace with actual data fetching logic
        // For demonstration, this uses sample data
        let sampleAppointments = [
            Appointment(id: UUID(), customerName: "John Doe", serviceType: "Haircut", time: Date(), status: "Confirmed"),
            Appointment(id: UUID(), customerName: "Jane Smith", serviceType: "Nail Care", time: Date().addingTimeInterval(3600), status: "Pending")
        ]
        self.appointments = sampleAppointments.filter {
            Calendar.current.isDate($0.time, inSameDayAs: date)
        }
    }
}

struct AppointmentsView: View {
    @ObservedObject var viewModel: AppointmentsViewModel
    
    var body: some View {
        VStack {
            DatePicker("Select Date", selection: $viewModel.selectedDate, displayedComponents: .date)
                .datePickerStyle(GraphicalDatePickerStyle())
                .onChange(of: viewModel.selectedDate) { newDate, _ in
                    viewModel.loadAppointments(for: newDate)
                }
                .padding()
            
            if viewModel.appointments.isEmpty {
                Text("No appointments on this date")
                    .font(.headline)
                    .padding()
            } else {
                List(viewModel.appointments) { appointment in
                    AppointmentRow(appointment: appointment)
                }
            }
            Spacer()
        }
        .navigationTitle("Appointments")
        .onAppear {
            viewModel.loadAppointments(for: viewModel.selectedDate)
        }
    }
}

// Reusable Appointment row
struct AppointmentRow: View {
    var appointment: Appointment
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(appointment.customerName)
                .font(.headline)
            Text(appointment.serviceType)
                .font(.subheadline)
                .foregroundColor(.gray)
            Text("Time: \(appointment.time.formatted(date: .omitted, time: .shortened))")
            Text("Status: \(appointment.status)")
                .font(.caption)
                .foregroundColor(appointment.status == "Confirmed" ? .green : .orange)
        }
        .padding(.vertical, 8)
    }
}

#Preview {
    let viewModel = AppointmentsViewModel(selectedDate: Date())
    AppointmentsView(viewModel: viewModel)
}
