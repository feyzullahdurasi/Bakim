//
//  ListingItemView.swift
//  Bakim
//
//  Created by Feyzullah Durası on 2.10.2024.
//

import SwiftUI

struct ListingItemView: View {
    var barberName: String
    var location: String
    var rating: String
    var bakim: Bakim?
    var business: Business?
    
    var body: some View {
        ZStack {
            // Background Card
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 5)
            
            HStack(spacing: 16) {
                
                if let business = business {
                    BakimRemoteImage(urlString: business.BusinessImage)
                        //.resizableImage()
                        .frame(width: 100, height: 100)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.gray.opacity(0.3), lineWidth: 2))
                        .shadow(radius: 5)
                } else {
                    // Placeholder image when no business is provided
                    //Circle()
                        //.fill(Color.gray.opacity(0.3))

                    Image("berber")
                        .resizable()
                        .frame(width: 100, height: 100)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.gray.opacity(0.3), lineWidth: 2))
                        .shadow(radius: 5)
                }
                
                // Barber Info (Name & Location)
                VStack(alignment: .leading, spacing: 8) {
                    // Barber Name
                    Text(barberName)
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                    
                    // Location
                    HStack {
                        Image(systemName: "mappin.and.ellipse")
                            .foregroundColor(.gray)
                        Text(location)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }
                
                Spacer()
                
                // Rating Section
                VStack {
                    Text(rating)
                        .font(.system(size: 15, weight: .bold))
                        .foregroundColor(.white)
                        .padding(5)
                        .background(Color.blue)
                        .cornerRadius(8)
                        .shadow(radius: 5)
                    
                    Text("Rating")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
            .padding()
        }
        .frame(height: 120)
        .padding(.horizontal, 8)
    }
}

