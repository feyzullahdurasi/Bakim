//
//  RemoteImage.swift
//  Bakim
//
//  Created by Feyzullah Durası on 31.10.2024.
//

import SwiftUI

final class ImageLoader: ObservableObject {
    @Published private(set) var state: ImageState = .loading
    private let cache = NSCache<NSString, UIImage>()
    
    enum ImageState {
        case loading
        case success(Image)
        case error
        
        var image: Image? {
            switch self {
            case .success(let image): return image
            default: return nil
            }
        }
    }
    
    func loadImage(from urlString: String) {
        let cacheKey = NSString(string: urlString)
        
        if let cachedImage = cache.object(forKey: cacheKey) {
            self.state = .success(Image(uiImage: cachedImage))
            return
        }
        
        self.state = .loading
        
        NetworkService.shared.downloadImage(from: urlString) { [weak self] uiImage in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                if let uiImage = uiImage {
                    self.cache.setObject(uiImage, forKey: cacheKey)
                    self.state = .success(Image(uiImage: uiImage))
                } else {
                    self.state = .error
                }
            }
        }
    }
    
    func cancelLoad() {
        // İleride request cancellation eklenebilir
    }
}
