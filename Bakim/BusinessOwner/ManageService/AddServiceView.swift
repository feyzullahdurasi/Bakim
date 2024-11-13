//
//  AddServiceView.swift
//  Bakim
//
//  Created by Feyzullah Durası on 12.11.2024.
//

import SwiftUI

struct AddServiceView: View {
    @State private var serviceName: String = ""
    @State private var localeName: String = ""
    @State private var carbohydrateContent: String = ""
    @State private var rating: String = ""
    @State private var comment: String = ""
    @State private var serviceImage: String = ""
    @ObservedObject var viewModel: ManageServicesViewModel

    var body: some View {
        Form {
            TextField("Service Name", text: $serviceName)
            TextField("Locale Name", text: $localeName)
            TextField("Carbohydrate Content", text: $carbohydrateContent)
            TextField("Rating", text: $rating)
            TextField("Comment", text: $comment)
            TextField("Service Image URL", text: $serviceImage)
            
            Button("Add Service") {
                let newService = ServiceEntity(
                    id: UUID().hashValue,
                    serviceName: serviceName,
                    localeName: localeName,
                    carbohydrateContent: carbohydrateContent,
                    rating: rating,
                    comment: comment,
                    serviceImage: serviceImage
                )
                //viewModel.addService(newService)
            }
        }
        .navigationTitle("Add Service")
    }
}
