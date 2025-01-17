//
//  HomeView.swift
//  Bakim
//
//  Created by Feyzullah Durası on 2.10.2024.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    @State private var showDestinationFilterView = false
    @State private var showSearchView = false
    @State private var searchWord = ""
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Arama ve filtreleme çubuğu
                FilterBar(
                    viewModel: viewModel,
                    showDestinationFilterView: $showDestinationFilterView,
                    showSearchView: $showSearchView,
                    searchWord: $searchWord
                )
                
                // Ana liste görünümü
                serviceListView()
            }
            .navigationTitle(viewModel.selectedServiceType?.name ?? "Tüm Hizmetler")
            .overlay {
                if viewModel.isLoading {
                    ProgressView()
                }
            }
            .alert("Hata", isPresented: $viewModel.hasError) {
                Button("Tamam", role: .cancel) {}
            } message: {
                Text(viewModel.error?.userErrorMessage ?? "Bilinmeyen bir hata oluştu")
            }
            .task {
                await viewModel.refreshData()
            }
        }
    }
    
    @ViewBuilder
    private func serviceListView() -> some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(viewModel.filteredServices) { service in
                    NavigationLink(
                        destination: ServiceDetailView(
                            service: service,
                            business: service.business ?? viewModel.currentBusiness!
                        )
                    ) {
                        ListingItemView(
                            business: service.business ?? viewModel.currentBusiness!,
                            service: service
                        )
                    }
                }
            }
            .padding()
        }
        .refreshable {
            await viewModel.refreshData()
        }
    }
}


#Preview {
    HomeView()
}
