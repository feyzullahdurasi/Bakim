//
//  LoginView.swift
//  Bakim
//
//  Created by Feyzullah Durası on 1.10.2024.
//

import SwiftUI

struct LoginView: View {
    @StateObject private var viewModel = LoginViewModel()

    var body: some View {
        VStack {
            // Lottie Animation View

            // Login Card
            VStack(spacing: 16) {
                TextField("E-posta", text: $viewModel.email)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 8).stroke(Color.gray, lineWidth: 1))
                    .padding(.top, 12)

                SecureField("Şifre", text: $viewModel.password)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 8).stroke(Color.gray, lineWidth: 1))

                Button(action: viewModel.login) {
                    Text("Giriş Yap")
                        .font(.system(size: 16))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(8)
                }
                .padding(.top, 16)

                Button(action: viewModel.loginWithGoogle) {
                    HStack {
                        Image("google_icon")
                            .resizable()
                            .frame(width: 24, height: 24)
                        Text("Google ile Giriş Yap")
                            .foregroundColor(.black)
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray, lineWidth: 1))
                }
                .padding(.top, 12)

                HStack {
                    Text("Hesabınız yok mu?")
                    NavigationLink(destination: RegisterView()) {
                        Text("Kayıt Ol")
                            .foregroundColor(.blue)
                    }
                }
                .padding(.top, 12)

                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                }
            }
            .padding()
            .background(Color.white)
            .cornerRadius(12)
            .shadow(radius: 8)
            .padding(.horizontal, 12)
        }
        .background(Color.gray.opacity(0.1).edgesIgnoringSafeArea(.all))
    }
}

#Preview {
    LoginView()
}
