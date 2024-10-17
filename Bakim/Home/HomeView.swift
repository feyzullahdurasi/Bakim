//
//  HomeView.swift
//  Bakim
//
//  Created by Feyzullah Durası on 2.10.2024.
//

import SwiftUI

struct HomeView: View {
    @ObservedObject var viewModel: HomeViewModel
    
    @State private var isDetailView = false
    @State private var showSearchView = false
    @State private var showDestinationSearchView = false
    @State private var searchWord = ""
    
    var body: some View {
        NavigationView {
            VStack {
                FilterBar(
                    showDestinationFilterView: $showDestinationSearchView,
                    showSearchView: $showSearchView,
                    searchWord: $searchWord
                )
                .transition(.move(edge: .top))
                .frame(height: 55)
                
                ScrollView {
                    LazyVStack(spacing: 16) {
                        ForEach(viewModel.services) { service in
                            ListingItemView(
                                barberName: service.serviceName ?? "Bilinmeyen Hizmet",
                                location: service.localeName ?? "Bilinmeyen Lokasyon",
                                rating: service.rating ?? "N/A",
                                image: getImageSource(from: service.serviceImage)
                            )
                            .onTapGesture {
                                isDetailView = true
                            }
                        }
                    }
                    .padding(.vertical)
                }
                .refreshable {
                    viewModel.refreshData(serviceType: viewModel.selectedServiceType)
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
            if viewModel.services.isEmpty {
                viewModel.refreshData(serviceType: viewModel.selectedServiceType)
            }
        }
    }
    
    private func getImageSource(from serviceImage: String?) -> String {
        if let image = serviceImage, !image.isEmpty {
            if image.hasPrefix("http://") || image.hasPrefix("https://") {
                return image
            } else {
                return "https://example.com/placeholder.jpg"
            }
        }
        return "https://example.com/placeholder.jpg"
    }
}



#Preview {
    HomeView(viewModel: HomeViewModel())
}
