//
//  RemoteImage.swift
//  Bakim
//
//  Created by Feyzullah Durası on 31.10.2024.
//

import SwiftUI

final class ImageLoader: ObservableObject {
    @Published var image: Image? = nil
    
    func loadImage(from urlString: String) {
        NetworkService.shared.downloadImage(from: urlString) { uiImage in
            guard let uiImage else { return }
            DispatchQueue.main.async {
                self.image = Image(uiImage: uiImage)
            }
        }
    }
}

struct RemoteImage: View {
    
    var image: Image?
    
    var body: some View {
        image?.resizable() ?? Image(systemName: "photo").resizable()
    }
}

struct BakimRemoteImage: View {
    
    @StateObject var imageLoader = ImageLoader()
    let urlString: String
    
    var body: some View {
        RemoteImage(image: imageLoader.image)
            .onAppear { imageLoader.loadImage(from: urlString) }
    }
    
}
