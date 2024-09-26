//
//  WomenHairdresserView.swift
//  Bakim
//
//  Created by Feyzullah Durası on 26.09.2024.
//

import SwiftUI

struct WomenHairdresserView: View {
    var body: some View {
        VStack {
            Text("Women's Hairdresser Services")
                .font(.title)
                .padding()

            // More options or services can be shown here
        }
        .navigationBarTitle("Women's Hairdresser", displayMode: .inline)
    }
}

#Preview {
    WomenHairdresserView()
}
