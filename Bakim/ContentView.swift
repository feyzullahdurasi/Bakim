//
//  ContentView.swift
//  Bakim
//
//  Created by Feyzullah Durası on 26.09.2024.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Ne tür bir hizmete ihtiyacınız var?")
                    .font(.title)
                    .padding(.top, 30)
                
                NavigationLink(destination: BarberView(serviceType: "Erkek Kuaför")) {
                    Text("Erkek Kuaför")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(width: 300, height: 50)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                
                NavigationLink(destination: BarberView(serviceType: "Kadın Kuaför")) {
                    Text("Kadın Kuaför")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(width: 300, height: 50)
                        .background(Color.pink)
                        .cornerRadius(10)
                }
                
                NavigationLink(destination: BarberView(serviceType: "Pet Kuaför")) {
                    Text("Pet Kuaför")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(width: 300, height: 50)
                        .background(Color.green)
                        .cornerRadius(10)
                }
                
                NavigationLink(destination: BarberView(serviceType: "Araba Yıkama")) {
                    Text("Araba Yıkama")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(width: 300, height: 50)
                        .background(Color.red)
                        .cornerRadius(10)
                }
            }
            .navigationTitle("Kuaför Uygulaması")
        }
    }
}

struct BarberView: View {
    var serviceType: String
    
    var body: some View {
        VStack {
            Text("\(serviceType) hizmeti seçtiniz.")
                .font(.largeTitle)
                .padding()
            // Diğer içerikler buraya eklenebilir (harita, liste vb.)
        }
        .navigationTitle(serviceType)
    }
}


#Preview {
    ContentView()
}
