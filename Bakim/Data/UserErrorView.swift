//
//  UserErrorView.swift
//  Bakim
//
//  Created by Feyzullah Durası on 3.10.2024.
//

import SwiftUI

struct UserErrorView: View {
    let error: APIError
    @Binding var isPresented: Bool
    @Environment(\.colorScheme) var colorScheme
    @Namespace var animation
    
    var body: some View {
        VStack(spacing: 25) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 50))
                .foregroundColor(.red)
                .padding(.top)
            
            Text("Hata")
                .font(.title)
                .fontWeight(.bold)
            
            Text(error.userErrorMessage)
                .font(.body)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            Button(action: {
                withAnimation(.spring()) {
                    isPresented = false
                }
            }) {
                Text("Tamam")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.accentColor)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding(.horizontal)
            .padding(.bottom)
        }
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 30)
                .fill(colorScheme == .dark ? Color(.systemGray6) : .white)
                .shadow(radius: 10)
        )
        .padding(.horizontal, 20)
    }
}
#Preview {
    UserErrorView(error: .invalidURL, isPresented: .constant(true))
}
