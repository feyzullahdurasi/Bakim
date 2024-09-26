//
//  MenHairdresserView.swift
//  Bakim
//
//  Created by Feyzullah Durası on 26.09.2024.
//

import SwiftUI

struct MenHairdresserView: View {
    var body: some View {
        VStack {
            Text("Men's Hairdresser Services")
                .font(.title)
                .padding()

            // Here you could display more detailed service options
        }
        .navigationBarTitle("Men's Hairdresser", displayMode: .inline)
    }
}

#Preview {
    MenHairdresserView()
}
