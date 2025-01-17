//
//  SearchView.swift
//  Bakim
//
//  Created by Feyzullah Durası on 5.10.2024.
//

import SwiftUI

struct SearchView: View {
    @Binding var show: Bool
    @Binding var searchWord: String
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
            TextField("Ara", text: $searchWord)
                .autocapitalization(.none)
                .disableAutocorrection(true)
            
            if !searchWord.isEmpty {
                Button {
                    searchWord = ""
                } label: {
                    Image(systemName: "xmark.circle.fill")
                }
            }
            
            Button {
                show.toggle()
            } label: {
                Image(systemName: "xmark.circle")
                    .imageScale(.large)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .clipShape(Capsule())
        .shadow(radius: 2)
    }
}

#Preview {
    SearchView(show: .constant(true), searchWord: .constant(""))
}
