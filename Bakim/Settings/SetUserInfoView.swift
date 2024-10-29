//
//  SetUserInfoView.swift
//  Bakim
//
//  Created by Feyzullah Durası on 28.10.2024.
//

import SwiftUI

struct SetUserInfoView: View {
    @Binding var fullName: String
    @Binding var email: String
    @Binding var businessName: String
    @Binding var location: String

    var body: some View {
        VStack(spacing: 20) {
            Text("Update Your Information")
                .font(.title2)
                .padding(.top)

            customTextField(title: "Name Surname", text: $fullName)
            customTextField(title: "Email", text: $email)
            
            if !businessName.isEmpty { // Only show if businessName is used
                customTextField(title: "Business Name", text: $businessName)
            }
            
            if !location.isEmpty { // Only show if location is used
                customTextField(title: "Location", text: $location)
            }

            Spacer()
        }
        .padding()
        .background(Color(UIColor.systemBackground))
    }

    private func customTextField(title: String, text: Binding<String>) -> some View {
        TextField(title, text: text)
            .padding()
            .background(Color(UIColor.systemGray5))
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.gray.opacity(0.5), lineWidth: 1)
            )
    }
}

#Preview {
    SetUserInfoView(fullName: .constant("Ali Rıza Beyoğlu"), email: .constant("cokzor@gmail.com"), businessName: .constant("YokBöyle Berber"), location: .constant("adres 1"))
}
