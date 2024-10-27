//
//  RegisterViewModel.swift
//  Bakim
//
//  Created by Feyzullah Durası on 1.10.2024.
//

import Foundation
import SwiftUI

class RegisterViewModel: ObservableObject {
    @Published var isBarber = false
    @Published var fullName = ""
    @Published var email = ""
    @Published var password = ""
    @Published var rePassword = ""
    @Published var businessName = ""
    @Published var location = ""
    @Published var selectedServices = [String]()
    @Published var errorMessage: String?
    @Published var isRegistered: Bool = false

    func register() {
        // Form doğrulama
        guard !fullName.isEmpty,
              !email.isEmpty,
              !password.isEmpty,
              password == rePassword else {
            errorMessage = "Please make sure you have filled out all fields correctly."
            return
        }

        // Kayıt işlemi (örneğin veritabanına kullanıcı kaydetme)
        print("Registration successful.")
        isRegistered = true
    }
}

struct ServicesSelectionView: View {
    @Binding var selectedServices: [String]
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Services")
                .font(.headline)
                .padding(.bottom, 4)

            // Checkboxes for services
            ForEach(serviceOptions, id: \.self) { service in
                Toggle(isOn: Binding(
                    get: { selectedServices.contains(service) },
                    set: { isSelected in
                        if isSelected {
                            selectedServices.append(service)
                        } else {
                            selectedServices.removeAll { $0 == service }
                        }
                    }
                )) {
                    Text(service)
                }
                .padding(.vertical, 4)
            }
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 8).stroke(Color.gray, lineWidth: 1))
    }
    
    private let serviceOptions = [
        "Men's Hairdresser", "Women's Hairdresser", "Pet Care", "Car Wash",
        "Skin Care", "Spa and Massage", "Nail Care"
    ]
}

