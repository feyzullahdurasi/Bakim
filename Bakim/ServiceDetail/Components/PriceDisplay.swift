//
//  PriceDisplay.swift
//  Bakim
//
//  Created by Feyzullah Durası on 13.01.2025.
//

import SwiftUI

struct PriceDisplay: View {
    let totalPrice: Int
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Total")
                .font(.caption)
                .foregroundColor(.gray)
            Text("\(totalPrice)₺")
                .font(.title2)
                .fontWeight(.bold)
        }
    }
}

#Preview {
    PriceDisplay(totalPrice: 122)
}
