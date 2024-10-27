//
//  RegisterView.swift
//  Bakim
//
//  Created by Feyzullah Durası on 1.10.2024.
//

import SwiftUI

struct RegisterView: View {
    @StateObject private var viewModel = RegisterViewModel()
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Toggle for business owner
                Toggle(isOn: $viewModel.isBarber) {
                    Text("I am a business owner")
                        .font(.headline)
                }
                .padding()
                .background(Color(UIColor.systemBackground))
                .cornerRadius(10)
                .shadow(radius: 2)

                // Conditional business owner fields
                if viewModel.isBarber {
                    businessOwnerFields
                }

                // Common fields
                commonFields

                // Register button
                Button(action: viewModel.register) {
                    Text("Sign Up")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .padding(.top)

                // Error message
                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding()
                }
            }
            .padding()
            .background(Color(UIColor.systemGroupedBackground))
        }
    }

    private var businessOwnerFields: some View {
        VStack(spacing: 15) {
            Button(action: {
                // Fotoğraf seçme işlemi
            }) {
                Text("Select Photo")
                    .frame(width: 120, height: 150)
                    .background(Color(UIColor.systemGray5))
                    .cornerRadius(10)
            }

            customTextField(title: "Business Name", text: $viewModel.businessName)
            customTextField(title: "Location", text: $viewModel.location)
            ServicesSelectionView(selectedServices: $viewModel.selectedServices)
        }
        .padding()
        .background(Color(UIColor.systemBackground))
        .cornerRadius(10)
        .shadow(radius: 2)
    }

    private var commonFields: some View {
        VStack(spacing: 15) {
            customTextField(title: "Name Surname", text: $viewModel.fullName)
            customTextField(title: "Email", text: $viewModel.email)
            customSecureField(title: "Password", text: $viewModel.password)
            customSecureField(title: "Repeat Password", text: $viewModel.rePassword)
        }
        .padding()
        .background(Color(UIColor.systemBackground))
        .cornerRadius(10)
        .shadow(radius: 2)
    }

    private func customTextField(title: String, text: Binding<String>) -> some View {
        TextField(title, text: text)
            .padding()
            .background(Color(UIColor.systemBackground))
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.gray.opacity(0.5), lineWidth: 1)
            )
    }

    private func customSecureField(title: String, text: Binding<String>) -> some View {
        SecureField(title, text: text)
            .padding()
            .background(Color(UIColor.systemBackground))
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.gray.opacity(0.5), lineWidth: 1)
            )
    }
}

#Preview {
    RegisterView()
}
