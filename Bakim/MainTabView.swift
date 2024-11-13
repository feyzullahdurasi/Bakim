//
//  MainTabView.swift
//  Bakim
//
//  Created by Feyzullah Durası on 2.10.2024.
//

import SwiftUI

struct MainTabView: View {
    @ObservedObject var viewModel: HomeViewModel
    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            // Home Tab
            HomeView(viewModel: viewModel)
                .tabItem {
                    Image(systemName: "house.fill")
                }
                .tag(0)

            // Maps Tab
            MapsView()
                .tabItem {
                    Image(systemName: "map.fill")
                }
                .tag(1)

            // Settings Tab
            SettingsView()
                .tabItem {
                    Image(systemName: "gearshape.fill")
                }
                .tag(2)
        }
        .navigationBarBackButtonHidden()
        .accentColor(.blue) // Customize the selected tab color
        .onAppear {
            // Ensure the Home tab is selected when the view appears
            selectedTab = 0
        }
    }
}

struct MapsView: View {
    var body: some View {
        VStack {
            Text("Maps")
                .font(.largeTitle)
                .padding()
            Spacer()
        }
    }
}

#Preview {
    MainTabView(viewModel: HomeViewModel())
}
