//
//  HomeView.swift
//  Bakim
//
//  Created by Feyzullah Durası on 2.10.2024.
//

import SwiftUI

struct HomeView: View {
    @ObservedObject var viewModel = HomeViewModel()
    @State private var isDetailView = false
    @State private var showSearchView = false
    @State private var showDestinationSearchView = false
    @State private var searchWord = ""
    @State private var showErrorView = false
    @State private var error: APIError?
    
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
                        if let business = viewModel.currentBusiness {
                            ForEach(business.services, id: \.serviceType) { service in
                                ListingItemView(
                                    barberName: service.serviceType.description,
                                    location: business.BusinessAddress,
                                    rating: getServicePriceRange(service),
                                    image: getImageSource(from: business.BusinessImage)
                                )
                                .onTapGesture {
                                    viewModel.selectedService = service
                                    isDetailView = true
                                }
                            }
                        }
                    }
                    .padding(.vertical)
                }
                .refreshable {
                    viewModel.refreshData()
                }
                .opacity(viewModel.isLoading ? 0 : 1)
                
                if viewModel.isLoading {
                    ProgressView()
                        .scaleEffect(1.5)
                        .padding()
                }
                
                if viewModel.hasError {
                    Text("Error loading services. Please try again!")
                        .font(.headline)
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                        .padding()
                }
            }
            .navigationTitle(viewModel.selectedServiceType?.description ?? "All Services")
            .sheet(isPresented: $isDetailView) {
                if let service = viewModel.selectedService, let business = viewModel.currentBusiness {
                    ServiceDetailView(service: service, business: business)
                }
            }
            .sheet(isPresented: $showErrorView) {
                if let error = error {
                    UserErrorView(Error: error, isPresented: $showErrorView)
                }
            }
            .onAppear {
                viewModel.refreshData()
            }
            .onChange(of: viewModel.error) { newError, _ in
                if let newError = newError {
                    error = newError
                    showErrorView = true
                }
            }
        }
        
    }
    
    private func getServicePriceRange(_ service: Service) -> String {
        let prices = service.serviceFeature.map { $0.price }
        if let minPrice = prices.min(), let maxPrice = prices.max() {
            return "\(minPrice)-\(maxPrice) USD"
        }
        return "Price varies"
    }
    
    private func getImageSource(from businessImage: String) -> String {
        if businessImage.hasPrefix("http://") || businessImage.hasPrefix("https://") {
            return businessImage
        }
        return "https://example.com/placeholder.jpg"
    }
}

#Preview {
    HomeView(viewModel: HomeViewModel())
}
