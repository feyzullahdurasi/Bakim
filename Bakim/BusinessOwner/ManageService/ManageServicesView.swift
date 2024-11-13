//
//  ManageServicesView.swift
//  Bakim
//
//  Created by Feyzullah Durası on 12.11.2024.
//

import SwiftUI

struct ManageServicesView: View {
    @ObservedObject var viewModel = ManageServicesViewModel()
    @State private var showAddServiceSheet = false
    @State private var selectedService: Service? = nil
    
    var body: some View {
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
                ForEach(viewModel.services, id: \.serviceType) { service in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(service.serviceType.description)
                                .font(.headline)
                            Text("Price Range: \(getPriceRange(for: service))")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        Spacer()
                        Button(action: {
                            selectedService = service
                        }) {
                            Text("Edit")
                        }
                        .buttonStyle(BorderlessButtonStyle())
                        .padding(.trailing)
                        
                        Button(action: {
                            viewModel.deleteService(service)
                        }) {
                            Image(systemName: "trash")
                                .foregroundColor(.red)
                        }
                        .buttonStyle(BorderlessButtonStyle())
                    }
                }
            }
            .listStyle(InsetGroupedListStyle())
            .sheet(isPresented: $showAddServiceSheet) {
                AddServiceView(viewModel: viewModel)
            }
            
        }
        .padding()
        .onAppear {
            viewModel.loadServices()
        }
    }
    
    // Price range hesaplamak için yardımcı fonksiyon
    private func getPriceRange(for service: Service) -> String {
        let prices = service.serviceFeature.map { $0.price }
        if let minPrice = prices.min(), let maxPrice = prices.max() {
            return "\(minPrice) - \(maxPrice)"
        }
        return "Price varies"
    }
}

#Preview {
    ManageServicesView()
}
