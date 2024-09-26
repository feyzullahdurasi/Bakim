//
//  CarWashView.swift
//  Bakim
//
//  Created by Feyzullah Durası on 26.09.2024.
//

import SwiftUI

struct CarWashView: View {
    var body: some View {
        VStack {
            Text("Car Wash Services")
                .font(.title)
                .padding()

            // More options or services
        }
        .navigationBarTitle("Car Wash", displayMode: .inline)
    }
}

#Preview {
    CarWashView()
}
