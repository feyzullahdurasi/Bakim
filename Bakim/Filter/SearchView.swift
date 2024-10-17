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
            Spacer()
            Button {
                withAnimation(.snappy) {
                    show.toggle()
                }
            } label: {
                Image(systemName: "xmark.circle")
                    .imageScale(.large)
            }
        }
        .frame(height: 50)
        .padding(.horizontal)
        .frame(maxWidth: .infinity)
        .overlay{
            Capsule()
                .stroke(lineWidth: 1)
                .foregroundColor(Color(.systemGray2))
                .shadow(color: .black.opacity(0.5), radius: 2)
        }
        .padding()
        
    }
}

#Preview {
    SearchView(show: .constant(true), searchWord: .constant(""))
}
