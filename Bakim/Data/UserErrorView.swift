//
//  UserErrorView.swift
//  Bakim
//
//  Created by Feyzullah Durası on 3.10.2024.
//

import SwiftUI

struct UserErrorView: View {
    let error: APIService.APIError
    @Binding var isPresented: Bool
    @Namespace var animation
    
    var body: some View {
        VStack(spacing: 25) {
            Text("Hata")
                .font(.title)
                .fontWeight(.bold)
            
            Text(error.userErrorMessage)
                .font(.body)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            Button("Tamam") {
                withAnimation {
                    isPresented = false
                }
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .frame(height: 410)
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 30))
        .padding(.horizontal, 20)
        .shadow(radius: 10)
    }
}
#Preview {
    UserErrorView(error: .invalidURL, isPresented: .constant(true))
}
