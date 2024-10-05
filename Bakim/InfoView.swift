//
//  HomeView.swift
//  Bakim
//
//  Created by Feyzullah Durası on 26.09.2024.
//

import SwiftUI

struct InfoView: View {
    @StateObject private var viewModel = HomeViewModel()
    @State private var navigateToMainTab = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    // Title
                    Text("Hizmet Seçimi")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(Color(red: 25/255, green: 46/255, blue: 165/255))

                    // Subtitle
                    Text("İhtiyacınız olan hizmeti seçin")
                        .font(.system(size: 16))
                        .padding(.bottom, 16)

                    // Buttons for services
                    VStack(spacing: 16) {
                        ServiceButton(title: "Erkek Kuaför", backgroundColor: Color.blue) {
                            selectService("Erkek Kuaför")
                        }
                        ServiceButton(title: "Kadın Kuaför", backgroundColor: Color.pink) {
                            selectService("Kadın Kuaför")
                        }
                        ServiceButton(title: "Pet Kuaför", backgroundColor: Color.green) {
                            selectService("Pet Kuaför")
                        }
                        ServiceButton(title: "Araba Yıkama", backgroundColor: Color.red) {
                            selectService("Araba Yıkama")
                        }
                        ServiceButton(title: "Çocuk Kuaför", backgroundColor: Color.orange) {
                            selectService("Çocuk Kuaför")
                        }
                        ServiceButton(title: "Spa ve Masaj", backgroundColor: Color.purple) {
                            selectService("Spa ve Masaj")
                        }
                        ServiceButton(title: "Tırnak Bakımı", backgroundColor: Color.cyan) {
                            selectService("Tırnak Bakımı")
                        }
                        ServiceButton(title: "Cilt Bakımı", backgroundColor: Color.yellow) {
                            selectService("Cilt Bakımı")
                        }
                    }
                }
                .padding()
            }
            .background(Color(UIColor.systemGray6))
            .navigationDestination(isPresented: $navigateToMainTab) {
                MainTabView(viewModel: viewModel)
            }
        }
        .overlay(
            Group {
                if viewModel.serviceLoading {
                    ProgressView()
                        .scaleEffect(1.5)
                        .padding()
                }
            }
        )
        .alert(isPresented: Binding<Bool>(
            get: { viewModel.serviceError },
            set: { _ in viewModel.serviceError = false }
        )) {
            Alert(title: Text("Hata"), message: Text("Veriler yüklenirken bir hata oluştu. Lütfen tekrar deneyin."), dismissButton: .default(Text("Tamam")))
        }
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
    }
    
    private func selectService(_ serviceType: String) {
        viewModel.refreshData(serviceType: serviceType)
        navigateToMainTab = true
    }
}

// Reusable service button component
struct ServiceButton: View {
    var title: String
    var backgroundColor: Color
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 18))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(backgroundColor)
                .cornerRadius(8)
        }
    }
}

#Preview {
    InfoView()
}
