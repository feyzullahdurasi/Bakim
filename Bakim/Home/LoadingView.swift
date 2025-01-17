//
//  LoadingView.swift
//  Bakim
//
//  Created by Feyzullah Durası on 31.10.2024.
//

import Foundation
import SwiftUI

struct activityIndicator: UIViewRepresentable {
    
   func makeUIView(context: Context) -> UIActivityIndicatorView {
       let activityIndicator = UIActivityIndicatorView(style: .medium)
       
       activityIndicator.startAnimating()
       return activityIndicator
    }
    
    func updateUIView(_ uiView: UIActivityIndicatorView, context: Context) {}
    
}
/*
struct LoadingView: View {
    var body: some View {
        ZStack {
            Color(.systemBackground)
                .opacity(0.8)
                .edgesIgnoringSafeArea(.all)
            
            ProgressView()
                .scaleEffect(1.5)
                .progressViewStyle(CircularProgressViewStyle(tint: .blue))
        }
    }
}
*/
