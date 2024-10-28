//
//  LoginView.swift
//  Bakim
//
//  Created by Feyzullah Durası on 1.10.2024.
//

import SwiftUI

struct LoginView: View {
    @StateObject private var viewModel = LoginViewModel()
    @State private var showLoadingOverlay = false

    var body: some View {
        NavigationStack {
            VStack {
                // Lottie Animation View
                
                VStack(spacing: 16) {
                    TextField("Email", text: $viewModel.email)
                        .autocapitalization(.none)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 8).stroke(Color.gray, lineWidth: 1))
                        .padding(.top, 12)
                    
                    SecureField("Password", text: $viewModel.password)
                        .autocapitalization(.none)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 8).stroke(Color.gray, lineWidth: 1))
                    
                    if let errorMessage = viewModel.errorMessage {
                        Text(errorMessage)
                            .foregroundColor(.red)
                    }
                    
                    Button(action: viewModel.login) {
                        Text("Sign In")
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
                            Text("Sign in with Google")
                                .foregroundColor(.black)
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray, lineWidth: 1))
                    }
                    .padding(.top, 12)
                    
                    HStack {
                        Text("Don't you have an account?")
                        NavigationLink(destination: RegisterView()) {
                            Text("Sign Up")
                                .foregroundColor(.blue)
                        }
                    }
                    .padding(.top, 12)
                    
                }
                .padding()
                .background(Color.white)
                .cornerRadius(12)
                .shadow(radius: 8)
                .padding(.horizontal, 12)
                
                .navigationDestination(isPresented: $viewModel.isLoggedIn) {
                    if viewModel.currentUser?.userType == .businessOwner {
                        BusinessOwnerView()
                    } else {
                        InfoView()
                    }
                }
            }
            .background(Color.gray.opacity(0.1).edgesIgnoringSafeArea(.all))
        }
    }
}

#Preview {
    LoginView()
}
