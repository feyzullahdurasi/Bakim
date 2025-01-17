//
//  ListingItemView.swift
//  Bakim
//
//  Created by Feyzullah Durası on 2.10.2024.
//

import SwiftUI

struct ListingItemView: View {
    let business: Business
    let service: Service
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.2), radius: 10)
            
            HStack(spacing: 16) {
                // İşyeri resmi
                BusinessImageView(imageURL: business.image)
                    .frame(width: 80, height: 80)
                    .clipShape(Circle())
                
                // İşyeri bilgileri
                VStack(alignment: .leading, spacing: 4) {
                    Text(business.name)
                        .font(.headline)
                        .lineLimit(1)
                    
                    Text(service.serviceType.name)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    Text(business.address)
                        .font(.caption)
                        .foregroundColor(.gray)
                        .lineLimit(2)
                }
                
                Spacer()
                
                // Fiyat ve puan
                VStack(spacing: 8) {
                    RatingView(rating: service.calculatedAverageRating)
                    
                    if service.minPrice > 0 {
                        Text("\(service.minPrice)₺'den")
                            .font(.caption)
                            .bold()
                            .foregroundColor(.blue)
                    }
                }
            }
            .padding()
        }
        .frame(height: 120)
    }
}

struct RatingView: View {
    let rating: Double
    
    var body: some View {
        HStack(spacing: 2) {
            Image(systemName: "star.fill")
                .foregroundColor(.yellow)
            Text(String(format: "%.1f", rating))
                .font(.caption)
        }
    }
}

extension Service {
    // Servisin minimum fiyatını hesaplama
    var minPrice: Int {
        serviceFeature.map { $0.price }.min() ?? 0
    }
    
    // Ortalama puanı hesaplama
    var calculatedAverageRating: Double {
        guard let comments = comments, !comments.isEmpty else { return 0 }
        let sum = comments.reduce(0) { $0 + $1.rating }
        return Double(sum) / Double(comments.count)
    }
}

