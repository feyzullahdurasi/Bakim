//
//  HomeView.swift
//  Bakim
//
//  Created by Feyzullah Durası on 26.09.2024.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                NavigationLink(destination: MenHairdresserView()) {
                    Text("Men's Hairdresser")
                        .font(.title2)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }

                NavigationLink(destination: WomenHairdresserView()) {
                    Text("Women's Hairdresser")
                        .font(.title2)
                        .padding()
                        .background(Color.pink)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }

                NavigationLink(destination: PetGroomerView()) {
                    Text("Pet Groomer")
                        .font(.title2)
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }

                NavigationLink(destination: CarWashView()) {
                    Text("Car Wash")
                        .font(.title2)
                        .padding()
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
            .navigationBarTitle("Services")
        }
    }
}

#Preview {
    HomeView()
}
