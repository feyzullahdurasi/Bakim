//
//  ManageServicesView.swift
//  Bakim
//
//  Created by Feyzullah Durası on 12.11.2024.
//

import SwiftUI

struct ManageServicesView: View {
    @StateObject private var viewModel = ManageServicesViewModel()
    @State private var showAddServiceSheet = false
    @State private var selectedService: Service? = nil
    
    var body: some View {
        LoadingView(isLoading: viewModel.isLoading) {
            VStack {
                HStack {
                    Text("manage_services")
                        .font(.largeTitle)
                        .bold()
                    Spacer()
                    Button(action: {
                        showAddServiceSheet = true
                    }) {
                        Image(systemName: "plus")
                            .padding()
                    }
                }
                .padding(.horizontal)
                
                List {
                    ForEach(viewModel.services) { service in
                        ServiceRow(
                            service: service,
                            onEdit: { selectedService = service },
                            onDelete: {
                                Task {
                                    await viewModel.deleteService(service)
                                }
                            }
                        )
                    }
                }
                .listStyle(InsetGroupedListStyle())
                .sheet(isPresented: $showAddServiceSheet) {
                    AddServiceView(viewModel: viewModel)
                }
                .sheet(item: $selectedService) { service in
                    EditServiceView(service: service, viewModel: viewModel)
                }
            }
            .alert("Error", isPresented: $viewModel.showError) {
                Button("OK") {}
            } message: {
                Text(viewModel.error?.userErrorMessage ?? "Unknown error occurred")
            }
        }
        .task {
            await viewModel.loadServices()
        }
    }
}

struct ServiceRow: View {
    let service: Service
    let onEdit: () -> Void
    let onDelete: () -> Void
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(service.serviceType.name)
                    .font(.headline)
                Text("Price Range: \(getPriceRange(for: service))")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            Spacer()
            Button(action: onEdit) {
                Text("Edit")
            }
            .buttonStyle(BorderlessButtonStyle())
            .padding(.trailing)
            
            Button(action: onDelete) {
                Image(systemName: "trash")
                    .foregroundColor(.red)
            }
            .buttonStyle(BorderlessButtonStyle())
        }
    }
    
    private func getPriceRange(for service: Service) -> String {
        let prices = service.serviceFeature.map { Double(truncating: $0.price as NSNumber) }
        if let minPrice = prices.min(), let maxPrice = prices.max() {
            return String(format: "%.2f₺ - %.2f₺", minPrice, maxPrice)
        }
        return "Price varies"
    }
}

#Preview {
    ManageServicesView()
}
