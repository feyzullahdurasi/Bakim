//
//  BusinessOwnerView.swift
//  Bakim
//
//  Created by Feyzullah Durası on 27.10.2024.
//

import SwiftUI

struct BusinessOwnerView: View {
    @State private var selectedDate = Date()
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Text("user_profile")
                        .font(.largeTitle)
                        .bold()
                    Spacer()
                    NavigationLink(destination: SettingsView()) {
                        Image(systemName: "gearshape")
                    }
                }
                .padding(.horizontal)
                
                Form {
                    // Income Section
                    Section(header: Text("income_overview")) {
                        NavigationLink {
                            MoneyHistoryView(viewModel: MoneyHistoryViewModel())
                        } label: {
                            HStack {
                                Text("business_income")
                                Spacer()
                                Text("6.950")
                                Text("TL")
                            }
                            .frame(height: 100)
                        }
                    }
                    
                    // Calendar Section
                    Section(header: Text("schedule")) {
                        DatePicker("select_date", selection: $selectedDate, displayedComponents: .date)
                            .datePickerStyle(GraphicalDatePickerStyle())
                            .frame(maxHeight: 400)
                        NavigationLink {
                            AppointmentsView(viewModel: AppointmentsViewModel(selectedDate: selectedDate))
                        } label: {
                            Text("view_appointments")
                        }
                    }
                    
                    // Additional features for Business Owner
                    Section(header: Text("business_tools")) {
                        NavigationLink {
                            ReportsView()
                        } label: {
                            Text("view_reports")
                        }
                        
                        NavigationLink {
                            ManageServicesView()
                        } label: {
                            Text("manage_services")
                        }
                        
                        NavigationLink {
                            FeedbackView(businessId: UserDefaults.standard.integer(forKey: "businessId"))
                        } label: {
                            Text("customer_feedback")
                        }
                    }
                }
            }
            .navigationBarBackButtonHidden()
        }
    }
}

#Preview {
    BusinessOwnerView()
}
