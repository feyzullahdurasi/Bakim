//
//  BusinessOwnerView.swift
//  Bakim
//
//  Created by Feyzullah Durası on 27.10.2024.
//

import SwiftUI

struct BusinessOwnerView: View {
    @State private var selectedDate = Date()
    
    var body: some View {
        NavigationView {
            VStack{
                HStack{
                    Text("User")
                        .font(.largeTitle)
                        .bold()
                    Spacer()
                    NavigationLink(destination: SettingsView()) {
                        Image(systemName: "gear")
                            .padding(.horizontal)
                    }
                }
                .padding(.horizontal)
                
                Form {
                    // Income Section
                    Section(header: Text("Income Overview")) {
                        NavigationLink(destination: MoneyHistoryView(viewModel: MoneyHistoryViewModel())) {
                            HStack {
                                Text("Business Income")
                                Spacer()
                                Text("950")
                                Text("TL")
                            }
                            .frame(height: 100)
                        }
                    }
                    
                    // Calendar Section
                    Section(header: Text("Schedule")) {
                        DatePicker("Select Date", selection: $selectedDate, displayedComponents: .date)
                            .datePickerStyle(GraphicalDatePickerStyle())
                            .frame(maxHeight: 400)
                        NavigationLink(destination: AppointmentsView(viewModel: AppointmentsViewModel(selectedDate: selectedDate))){
                            Text("View Appointments")
                        }
                    }
                    
                    // Additional features for Business Owner
                    Section(header: Text("Business Tools")) {
                        Button("View Reports") {
                            // Implement business report view
                        }
                        Button("Manage Services") {
                            // Implement service management view
                        }
                        Button("Customer Feedback") {
                            // Implement feedback view
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    BusinessOwnerView()
}
