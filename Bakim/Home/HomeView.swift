//
//  HomeView.swift
//  Bakim
//
//  Created by Feyzullah Durası on 2.10.2024.
//

import SwiftUI

struct HomeView: View {
    @ObservedObject var viewModel: HomeViewModel

    var body: some View {
        NavigationView {
            ZStack {
                ScrollView {
                    LazyVStack {
                        ForEach(viewModel.services) { service in
                            ServiceRowView(service: service)
                                .padding(.horizontal)
                        }
                    }
                    .refreshable {
                        viewModel.refreshData(serviceType: viewModel.selectedServiceType)
                    }
                }
                .opacity(viewModel.serviceLoading || viewModel.serviceError ? 0 : 1)

                if viewModel.serviceLoading {
                    ProgressView()
                        .scaleEffect(1.5)
                        .padding()
                }

                if viewModel.serviceError {
                    Text("Hata! Tekrardan Deneyiniz!")
                        .font(.headline)
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                        .padding()
                }
            }
            .navigationTitle(viewModel.selectedServiceType ?? "Hizmetler")
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                if viewModel.services.isEmpty {
                    viewModel.refreshData(serviceType: viewModel.selectedServiceType)
                }
            }
        }
    }
}

struct ServiceRowView: View {
    let service: ServiceEntity

    var body: some View {
        HStack {
            Image(systemName: "person.crop.circle.fill")
                .resizable()
                .frame(width: 60, height: 60)
                .background(Circle().fill(Color.gray).opacity(0.1))
                .padding(.trailing, 8)

            VStack(alignment: .leading) {
                Text(service.serviceName ?? "Bilinmeyen Hizmet")
                    .font(.headline)
                Text(service.localeName ?? "Bilinmeyen Lokasyon")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            Spacer()

            if let rating = service.rating {
                Text(rating)
                    .font(.headline)
                    .padding(8)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .clipShape(Circle())
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 4)
        )
        .padding(.vertical, 4)
    }
}

#Preview {
    HomeView(viewModel: HomeViewModel())
}
