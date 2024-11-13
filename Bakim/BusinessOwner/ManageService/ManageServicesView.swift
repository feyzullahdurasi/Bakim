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
                Text("Manage Services")
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
                ForEach(viewModel.services, id: \.id) { service in
                    HStack {
                        VStack(alignment: .leading) {
                            //Text(service.serviceType.description)
                                //.font(.headline)
                            //Text("Price Range: \(viewModel.getPriceRange(service))")
                                //.font(.subheadline)
                                //.foregroundColor(.gray)
                        }
                        Spacer()
                        Button(action: {
                            //selectedService = service
                        }) {
                            Text("Edit")
                        }
                        .buttonStyle(BorderlessButtonStyle())
                        .padding(.trailing)
                        
                        Button(action: {
                            //viewModel.deleteService(service)
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
            //viewModel.loadServices()
        }
    }
}

#Preview {
    ManageServicesView()
}
