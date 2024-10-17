//
//  FilterBar.swift
//  Bakim
//
//  Created by Feyzullah Durası on 5.10.2024.
//

import SwiftUI

struct FilterBar: View {
    
    @Binding var showDestinationFilterView: Bool
    @Binding var showSearchView: Bool
    @Binding var searchWord: String
    @State private var isHeartFilled = false
    @State private var isShared = false
    
    var body: some View {
        NavigationStack {
            VStack {
                if showDestinationFilterView {
                    DestinationFilterView(show: $showDestinationFilterView)
                        .fullScreenCover(isPresented: $showDestinationFilterView) {
                            DestinationFilterView(show: $showDestinationFilterView)
                                    }
                } else if showSearchView {
                    SearchView(show: $showSearchView, searchWord: $searchWord)
                } else {
                    HStack {
                        
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
                    .frame(height: 50) // Ana görünümde yükseklik 50
                }
            }
            
        }
    }
}

#Preview {
    FilterBar(showDestinationFilterView: .constant(false), showSearchView: .constant(false), searchWord: .constant(""))
}
