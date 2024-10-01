//
//  RegisterView.swift
//  Bakim
//
//  Created by Feyzullah Durası on 1.10.2024.
//

import SwiftUI

struct RegisterView: View {
    @StateObject private var viewModel = RegisterViewModel()

    var body: some View {
        ScrollView {
            VStack {
                // Register Card
                RoundedRectangle(cornerRadius: 0)
                    .fill(Color.white)
                    .shadow(radius: 8)
                    .padding(.horizontal, 12)
                    .overlay(
                        VStack(alignment: .leading, spacing: 16) {
                            Toggle(isOn: $viewModel.isBarber) {
                                Text("Bir işletme sahibiyim.")
                            }
                            .padding(.top, 12)

                            if viewModel.isBarber {
                                VStack(spacing: 16) {
                                    Button(action: {
                                        // Fotoğraf seçme işlemi
                                    }) {
                                        Text("Fotoğraf Seç")
                                            .frame(width: 120, height: 150)
                                            .background(Color.gray.opacity(0.2))
                                            .cornerRadius(8)
                                    }

                                    TextField("İşletme Adı", text: $viewModel.businessName)
                                        .padding()
                                        .background(RoundedRectangle(cornerRadius: 8).stroke(Color.gray, lineWidth: 1))

                                    TextField("Konum", text: $viewModel.location)
                                        .padding()
                                        .background(RoundedRectangle(cornerRadius: 8).stroke(Color.gray, lineWidth: 1))

                                    ServicesSelectionView(selectedServices: $viewModel.selectedServices)
                                }
                                .transition(.slide)
                            }

                            TextField("Ad Soyad", text: $viewModel.fullName)
                                .padding()
                                .background(RoundedRectangle(cornerRadius: 8).stroke(Color.gray, lineWidth: 1))

                            TextField("E-posta", text: $viewModel.email)
                                .padding()
                                .background(RoundedRectangle(cornerRadius: 8).stroke(Color.gray, lineWidth: 1))

                            SecureField("Şifre", text: $viewModel.password)
                                .padding()
                                .background(RoundedRectangle(cornerRadius: 8).stroke(Color.gray, lineWidth: 1))

                            SecureField("Şifreyi Tekrarla", text: $viewModel.rePassword)
                                .padding()
                                .background(RoundedRectangle(cornerRadius: 8).stroke(Color.gray, lineWidth: 1))

                            Button(action: viewModel.register) {
                                Text("Kayıt Ol")
                                    .font(.system(size: 16))
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.blue)
                                    .cornerRadius(8)
                            }
                            .padding(.top, 16)

                            if let errorMessage = viewModel.errorMessage {
                                Text(errorMessage)
                                    .foregroundColor(.red)
                            }
                        }
                        .padding(16)
                    )
            }
            .background(Color(UIColor.systemGray6))
        }
    }
}

#Preview {
    RegisterView()
}
