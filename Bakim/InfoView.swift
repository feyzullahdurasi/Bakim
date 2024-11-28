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
                    Text(LocalizedStringKey("Service Selection"))
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(Color(red: 25/255, green: 46/255, blue: 165/255))

                    // Subtitle
                    Text(LocalizedStringKey("Select the service you need"))
                        .font(.system(size: 16))
                        .padding(.bottom, 32)

                    // Buttons for services
                    VStack(spacing: 16) {
                        ForEach(ServiceType.allCases, id: \.self) { serviceType in
                            ServiceButton(title: serviceType.description, backgroundColor: getColor(for: serviceType)) {
                                selectService(serviceType)
                            }
                        }
                    }
                }
                .padding()
            }
            .background(Color(UIColor.systemGray6))
            .navigationDestination(isPresented: $navigateToMainTab) {
                MainTabView(viewModel: viewModel) // Ensure this view is correctly initialized
            }
        }
        .overlay(
            Group {
                if viewModel.isLoading {
                    ProgressView()
                        .scaleEffect(1.5)
                        .padding()
                }
            }
        )
        .alert(isPresented: Binding<Bool>(
            get: { viewModel.hasError },
            set: { _ in viewModel.hasError = false }
        )) {
            Alert(title: Text("Error"), message: Text("An error occurred while loading data. Please try again."), dismissButton: .default(Text("OK")))
        }
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
    }
    
    private func selectService(_ serviceType: ServiceType) {
        viewModel.selectedServiceType = serviceType
        viewModel.refreshData(serviceType: serviceType)
        navigateToMainTab = true
    }
    
    private func getColor(for serviceType: ServiceType) -> Color {
        switch serviceType {
        case .menHairdresser: return .blue
        case .womenHairdresser: return .pink
        case .petCare: return .green
        case .carWash: return .red
        case .skinCare: return .orange
        case .spaMassage: return .purple
        case .nailCare: return .cyan
        case .homeCleaner: return .blue
        case .eventSpacesRental: return .yellow
        }
    }
}

// Reusable service button component
struct ServiceButton: View {
    var title: String
    var backgroundColor: Color
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(LocalizedStringKey(title))
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
