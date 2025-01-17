//
//  HomeView.swift
//  Bakim
//
//  Created by Feyzullah Durası on 26.09.2024.
//

import SwiftUI

struct InfoView: View {
    @StateObject private var viewModel = InfoViewModel()
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
                    
                    // Service Types from backend
                    VStack(spacing: 16) {
                        ForEach(viewModel.serviceTypes) { serviceType in
                            ServiceButton(
                                title: serviceType.name,
                                description: serviceType.description ?? "",
                                backgroundColor: getColor(for: serviceType.id)
                            ) {
                                selectService(serviceType)
                            }
                        }
                    }
                }
                .padding()
            }
            .background(Color(UIColor.systemGray6))
            .navigationDestination(isPresented: $navigateToMainTab) {
                MainTabView(viewModel: HomeViewModel(selectedServiceType: viewModel.selectedServiceType))
            }
            .task {
                await viewModel.loadServiceTypes()
            }
        }
        .overlay {
            if viewModel.isLoading {
                ProgressView()
                    .scaleEffect(1.5)
                    .padding()
            }
        }
        .alert("Error", isPresented: $viewModel.hasError) {
            Button("OK") {}
        } message: {
            Text(viewModel.error?.userErrorMessage ?? "Unknown error occurred")
        }
    }
    
    private func selectService(_ serviceType: ServiceType) {
        viewModel.selectedServiceType = serviceType
        navigateToMainTab = true
    }
    
    private func getColor(for serviceTypeId: Int) -> Color {
        // Dinamik renk ataması için ID'ye göre renk döndür
        let colors: [Color] = [.blue, .pink, .green, .red, .orange, .purple, .cyan, .yellow]
        return colors[serviceTypeId % colors.count]
    }
}

// Yeni ViewModel oluşturalım
@MainActor
class InfoViewModel: ObservableObject {
    @Published private(set) var serviceTypes: [ServiceType] = []
    @Published private(set) var isLoading = false
    @Published var hasError = false
    @Published var error: APIError?
    @Published var selectedServiceType: ServiceType?
    
    private let networkService: NetworkService
    
    init(networkService: NetworkService = .shared) {
        self.networkService = networkService
    }
    
    func loadServiceTypes() async {
        isLoading = true
        hasError = false
        error = nil
        
        do {
            serviceTypes = try await networkService.request(
                endpoint: "/service-types",
                method: "GET"
            )
        } catch {
            self.error = error as? APIError ?? .unableToComplete
            hasError = true
        }
        
        isLoading = false
    }
}

// Güncellenen ServiceButton
struct ServiceButton: View {
    let title: String
    let description: String
    let backgroundColor: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 4) {
                Text(LocalizedStringKey(title))
                    .font(.system(size: 18, weight: .semibold))
                
                if !description.isEmpty {
                    Text(LocalizedStringKey(description))
                        .font(.system(size: 14))
                        .opacity(0.8)
                }
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            .background(backgroundColor)
            .cornerRadius(8)
        }
    }
}

#Preview {
    InfoView()
}
