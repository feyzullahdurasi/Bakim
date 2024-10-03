//
//  MainTabView.swift
//  Bakim
//
//  Created by Feyzullah Durası on 2.10.2024.
//

import SwiftUI

struct MainTabView: View {
    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            // Home Tab
            HomeView()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }
                .tag(0)

            // Maps Tab
            MapsView()
                .tabItem {
                    Image(systemName: "map.fill")
                    Text("Maps")
                }
                .tag(1)

            // Settings Tab
            SettingsView()
                .tabItem {
                    Image(systemName: "gearshape.fill")
                    Text("Settings")
                }
                .tag(2)
        }
        .accentColor(.blue) // Customize the selected tab color
    }
}

struct Home2View: View {
    var body: some View {
        VStack {
            Text("Home")
                .font(.largeTitle)
                .padding()
            Spacer()
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

struct SettingsView: View {
    var body: some View {
        VStack {
            Text("Settings")
                .font(.largeTitle)
                .padding()
            Spacer()
        }
    }
}


#Preview {
    MainTabView()
}
