//
//  ReservationButton.swift
//  Bakim
//
//  Created by Feyzullah Durası on 13.01.2025.
//

import SwiftUI

struct ReservationButton: View {
    let isEnabled: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text("Make Reservation")
                .font(.headline)
                .foregroundColor(.white)
                .padding()
                .frame(width: 200)
                .background(isEnabled ? Color.blue : Color.gray)
                .cornerRadius(10)
        }
        .disabled(!isEnabled)
    }
}

