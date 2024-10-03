//
//  HomeView.swift
//  Bakim
//
//  Created by Feyzullah Durası on 26.09.2024.
//

import SwiftUI

struct InfoView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                // Title
                Text("Hizmet Seçimi")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(Color(red: 25/255, green: 46/255, blue: 165/255))

                // Subtitle
                Text("İhtiyacınız olan hizmeti seçin")
                    .font(.system(size: 16))
                    .padding(.bottom, 16)

                // Buttons for services
                VStack(spacing: 16) {
                    ServiceButton(title: "Erkek Kuaför", backgroundColor: Color.blue)
                    ServiceButton(title: "Kadın Kuaför", backgroundColor: Color.pink)
                    ServiceButton(title: "Pet Kuaför", backgroundColor: Color.green)
                    ServiceButton(title: "Araba Yıkama", backgroundColor: Color.red)
                    ServiceButton(title: "Çocuk Kuaför", backgroundColor: Color.orange)
                    ServiceButton(title: "Spa ve Masaj", backgroundColor: Color.purple)
                    ServiceButton(title: "Tırnak Bakımı", backgroundColor: Color.cyan)
                    ServiceButton(title: "Cilt Bakımı", backgroundColor: Color.yellow)
                }
            }
            .padding()
        }
        .background(Color(UIColor.systemGray6))
    }
}

// Reusable service button component
struct ServiceButton: View {
    var title: String
    var backgroundColor: Color
    
    var body: some View {
        Button(action: {
            // Action for button
        }) {
            Text(title)
                .font(.system(size: 18))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(backgroundColor)
                .cornerRadius(8)
        }
    }
}

#Preview {
    InfoView()
}
