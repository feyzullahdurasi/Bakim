//
//  HomeView.swift
//  Bakim
//
//  Created by Feyzullah Durası on 2.10.2024.
//

import SwiftUI

struct HomeView: View {
    @State private var isRefreshing = false
    @State private var isLoading = true
    @State private var hasError = false
    @State private var barbers: [Barber] = []

    var body: some View {
        ZStack {
            // Swipe to refresh list
            ScrollView {
                LazyVStack {
                    ForEach(barbers) { barber in
                        BarberRowView(barber: barber)
                            .padding(.horizontal)
                    }
                }
                .refreshable {
                    loadData()
                }
            }
            .opacity(isLoading || hasError ? 0 : 1) // Hide list when loading or error

            // Show progress bar when loading
            if isLoading {
                ProgressView()
                    .scaleEffect(1.5)
                    .padding()
            }

            // Error message when data fails to load
            if hasError {
                Text("Hata! Tekrardan Deneyiniz!")
                    .font(.headline)
                    .foregroundColor(.red)
                    .multilineTextAlignment(.center)
                    .padding()
            }
        }
        .onAppear {
            loadData()
        }
    }

    // Mock data loading function
    func loadData() {
        isLoading = true
        hasError = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            // Simulate network call
            if Bool.random() {
                // On success
                services = [
                    ServiceEntity(id: 1, name: "Selim Serdar Kuaför", location: "Aydınlı Mah. Merkez", rating: 4.5),
                    ServiceEntity(id: 2, name: "Osman Usta Kuaför", location: "Pendik Merkez", rating: 4.8),
                    ServiceEntity(id: 3, name: "Barber John", location: "Downtown", rating: 4.3)
                ]
                isLoading = false
            } else {
                // On failure
                hasError = true
                isLoading = false
            }
        }
    }
}

struct Barber: Identifiable {
    let id: Int
    let name: String
    let location: String
    let rating: Double
}

struct BarberRowView: View {
    let barber: Barber

    var body: some View {
        HStack {
            // Barber image (Placeholder for now)
            Image(systemName: "person.crop.circle.fill")
                .resizable()
                .frame(width: 60, height: 60)
                .background(Circle().fill(Color.gray).opacity(0.1))
                .padding(.trailing, 8)

            // Barber Info
            VStack(alignment: .leading) {
                Text(barber.name)
                    .font(.headline)
                Text(barber.location)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            Spacer()

            // Rating
            Text(String(format: "%.1f", barber.rating))
                .font(.headline)
                .padding(8)
                .background(Color.blue)
                .foregroundColor(.white)
                .clipShape(Circle())
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 4)
        )
        .padding(.vertical, 4)
    }
}

#Preview {
    HomeView()
}
