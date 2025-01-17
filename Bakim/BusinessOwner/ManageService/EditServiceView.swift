//
//  EditServiceView.swift
//  Bakim
//
//  Created by Feyzullah Durası on 13.01.2025.
//

import SwiftUI

struct EditServiceView: View {
    @State private var serviceType: String
    @State private var serviceDescription: String
    @State private var features: [ServiceFeature]
    @ObservedObject var viewModel: ManageServicesViewModel
    @Environment(\.dismiss) var dismiss
    
    let service: Service
    
    init(service: Service, viewModel: ManageServicesViewModel) {
        self.service = service
        self.viewModel = viewModel
        _serviceType = State(initialValue: service.serviceType.name)
        _serviceDescription = State(initialValue: service.serviceType.description ?? "")
        _features = State(initialValue: service.serviceType.features ?? [])
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Service Type")) {
                    TextField("Enter service type", text: $serviceType)
                    TextField("Description", text: $serviceDescription, axis: .vertical)
                        .lineLimit(3...6)
                }
                
                Section(header: Text("Features")) {
                    ForEach($features) { $feature in
                        VStack(alignment: .leading) {
                            TextField("Feature Name", text: $feature.name)
                            HStack {
                                TextField("Price", value: $feature.price, format: .currency(code: "TRY"))
                                    .keyboardType(.decimalPad)
                                Spacer()
                                TextField("Duration (min)", value: $feature.duration, format: .number)
                                    .keyboardType(.numberPad)
                            }
                        }
                    }
                    .onDelete(perform: deleteFeature)
                    
                    Button("Add Feature") {
                        let newFeature = ServiceFeature(
                            id: (features.map { $0.id }.max() ?? 0) + 1,
                            name: "",
                            price: Int(0),
                            duration: 0
                        )
                        features.append(newFeature)
                    }
                }
            }
            .navigationTitle("Edit Service")
            .navigationBarItems(leading: cancelButton, trailing: saveButton)
            .alert("Error", isPresented: $viewModel.showError, presenting: viewModel.error) { _ in
                Button("OK") {}
            } message: { error in
                Text(error.localizedDescription)
            }
        }
    }
    
    private var cancelButton: some View {
        Button("Cancel") {
            dismiss()
        }
    }
    
    private var saveButton: some View {
        Button("Save") {
            Task {
                let updatedServiceType = ServiceType(
                    id: service.serviceType.id,
                    name: serviceType,
                    description: serviceDescription,
                    features: features
                )
                
                let updatedService = Service(
                    id: service.id,
                    serviceType: updatedServiceType,
                    serviceFeature: features
                )
                
                await viewModel.updateService(updatedService)
                if !viewModel.showError {
                    dismiss()
                }
            }
        }
        .disabled(serviceType.isEmpty || features.isEmpty || features.contains { $0.name.isEmpty })
    }
    
    private func deleteFeature(at offsets: IndexSet) {
        features.remove(atOffsets: offsets)
    }
}
