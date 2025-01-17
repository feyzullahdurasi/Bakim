//
//  FilterBar.swift
//  Bakim
//
//  Created by Feyzullah Durası on 5.10.2024.
//

import SwiftUI

struct FilterBar: View {
    @ObservedObject var viewModel: HomeViewModel
    @Binding var showDestinationFilterView: Bool
    @Binding var showSearchView: Bool
    @Binding var searchWord: String
    
    var body: some View {
        NavigationStack {
            VStack {
                if showDestinationFilterView {
                    DestinationFilterView(
                        show: $showDestinationFilterView,
                        onFilter: { minPrice, maxPrice, location in
                            Task {
                                await viewModel.applyFilters(
                                    minPrice: Double(minPrice),
                                    maxPrice: Double(maxPrice),
                                    location: location
                                )
                            }
                        }
                    )
                } else if showSearchView {
                    SearchView(show: $showSearchView, searchWord: $searchWord)
                        .onChange(of: searchWord) { _, newValue in
                            Task {
                                await viewModel.searchServices(query: newValue)
                            }
                        }
                } else {
                    HStack {
                        filterButton
                        searchButton
                        shareButton
                    }
                    .frame(height: 50)
                }
            }
        }
    }
    
    // MARK: - View Components
    private var filterButton: some View {
        HStack {
            Image(systemName: "list.bullet.indent")
            Text("Filtre")
        }
        .frame(width: UIScreen.main.bounds.width / 2.5, height: 50)
        .overlay {
            Capsule()
                .stroke(lineWidth: 1)
                .foregroundColor(Color(.systemGray2))
                .shadow(color: .black.opacity(0.5), radius: 2)
        }
        .onTapGesture {
            withAnimation(.snappy) {
                showDestinationFilterView.toggle()
            }
        }
    }
    
    private var searchButton: some View {
        HStack {
            Image(systemName: "magnifyingglass")
            Text("Ara")
        }
        .frame(width: UIScreen.main.bounds.width / 2.5, height: 50)
        .overlay {
            Capsule()
                .stroke(lineWidth: 1)
                .foregroundColor(Color(.systemGray2))
                .shadow(color: .black.opacity(0.5), radius: 2)
        }
        .onTapGesture {
            withAnimation(.snappy) {
                showSearchView.toggle()
            }
        }
    }
    
    private var shareButton: some View {
        HStack {
            ShareLink(item: URL(string: "https://github.com/feyzullahdurasi")!) {
                Image(systemName: "person.2")
                    .foregroundColor(.black)
            }
        }
        .frame(width: UIScreen.main.bounds.width / 8, height: 50)
        .overlay {
            Capsule()
                .stroke(lineWidth: 1)
                .foregroundColor(Color(.systemGray2))
                .shadow(color: .black.opacity(0.5), radius: 2)
        }
    }
}

#Preview {
    FilterBar(
        viewModel: HomeViewModel(),
        showDestinationFilterView: .constant(false),
        showSearchView: .constant(false),
        searchWord: .constant("")
    )
}
