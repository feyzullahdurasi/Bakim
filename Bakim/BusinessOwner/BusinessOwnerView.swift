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
            VStack{
                HStack{
                    Text("user_profile")
                        .font(.largeTitle)
                        .bold()
                    Spacer()
                    Button(action: {
                        logout()
                        presentationMode.wrappedValue.dismiss()  // Bir önceki sayfaya dön
                    }) {
                        Text("exit")
                            .foregroundColor(.red)
                    }
                }
                .padding(.horizontal)
                
                Form {
                    // Income Section
                    Section(header: Text("income_overview")) {
                        NavigationLink(destination: MoneyHistoryView(viewModel: MoneyHistoryViewModel())) {
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
                        NavigationLink(destination: AppointmentsView(viewModel: AppointmentsViewModel(selectedDate: selectedDate))){
                            Text("view_appointments")
                        }
                    }
                    
                    // Additional features for Business Owner
                    Section(header: Text("business_tools")) {
                        NavigationLink(destination: ReportsView()) {
                            Text("view_reports")
                        }
                        NavigationLink(destination: ManageServicesView()) {
                            Text("manage_services")
                        }
                        NavigationLink( destination: FeedbackView(viewModel: FeedbackViewModel())) {
                            Text("customer_feedback")
                        }
                    }
                }
            }
            .navigationBarBackButtonHidden()
        }
    }
    
    func logout() {
        // Örnek olarak, kullanıcı verilerini temizleyebilir veya UserDefaults'tan silinebilir
        UserDefaults.standard.removeObject(forKey: "isLoggedIn")  // Örneğin giriş durumunu temizlemek
        // Oturum kapatma işlemleri burada yapılır.
    }
}

#Preview {
    BusinessOwnerView()
}
