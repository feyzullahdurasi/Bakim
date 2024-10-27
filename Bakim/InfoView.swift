//
//  HomeView.swift
//  Bakim
//
//  Created by Feyzullah Durası on 26.09.2024.
//

import SwiftUI

struct InfoView: View {
    @StateObject private var viewModel = HomeViewModel()
    @State private var navigateToMainTab = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    // Title
                    Text("Service Selection")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(Color(red: 25/255, green: 46/255, blue: 165/255))

                    // Subtitle
                    Text("Select the service you need")
                        .font(.system(size: 16))
                        .padding(.bottom, 32)

                    // Buttons for services
                    VStack(spacing: 16) {
                        ServiceButton(title: NSLocalizedString("Men's Hairdresser", comment: "Men's Hairdresser option"), backgroundColor: Color.blue) {
                            selectService("Men's Hairdresser")
                        }
                        ServiceButton(title: NSLocalizedString("Women's Hairdresser", comment: "Women's Hairdresser option"), backgroundColor: Color.pink) {
                            selectService("Women's Hairdresser")
                        }
                        ServiceButton(title: NSLocalizedString("Pet Care", comment: "Pet Care option"), backgroundColor: Color.green) {
                            selectService("Pet Care")
                        }
                        ServiceButton(title: NSLocalizedString("Car Wash", comment: "Car Wash option"), backgroundColor: Color.red) {
                            selectService("Car Wash")
                        }
                        ServiceButton(title: NSLocalizedString("Skin Care", comment: "Skin Care option"), backgroundColor: Color.orange) {
                            selectService("Skin Care")
                        }
                        ServiceButton(title: NSLocalizedString("Spa and Massage", comment: "Spa and Massage option"), backgroundColor: Color.purple) {
                            selectService("Spa and Massage")
                        }
                        ServiceButton(title: NSLocalizedString("Nail Care", comment: "Nail Care option"), backgroundColor: Color.cyan) {
                            selectService("Nail Care")
                        }
                    }
                }
                .padding()
            }
            .background(Color(UIColor.systemGray6))
            .navigationDestination(isPresented: $navigateToMainTab) {
                MainTabView(viewModel: viewModel)
            }
        }
        .overlay(
            Group {
                if viewModel.serviceLoading {
                    ProgressView()
                        .scaleEffect(1.5)
                        .padding()
                }
            }
        )
        .alert(isPresented: Binding<Bool>(
            get: { viewModel.serviceError },
            set: { _ in viewModel.serviceError = false }
        )) {
            Alert(title: Text("Hata"), message: Text("Veriler yüklenirken bir hata oluştu. Lütfen tekrar deneyin."), dismissButton: .default(Text("Tamam")))
        }
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
    }
    
    private func selectService(_ serviceType: String) {
        viewModel.refreshData(serviceType: serviceType)
        navigateToMainTab = true
    }
}

// Reusable service button component
struct ServiceButton: View {
    var title: String
    var backgroundColor: Color
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 18))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(backgroundColor)
                .cornerRadius(8)
        }
    }
}

#Preview {
    InfoView()
}
