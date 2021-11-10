//
//  CachedImageView.swift
//  TestLeboncoiniOS
//
//  Created by Koussaïla Ben Mamar on 03/10/2021.
//

import UIKit

// Les frameworks externes sont interdits dans ce test, le faisant de base avec Kingfisher.
class CachedImageView: UIImageView {
    private static let imageCache = NSCache<AnyObject, UIImage>()
    
    func loadImage(fromURL imageURL: URL, placeholderImage: String) {
        // Image temporaire ou maintenue si l'image de l'URL est indisponible
        self.image = UIImage(named: placeholderImage)
        
        if let cachedImage = CachedImageView.imageCache.object(forKey: imageURL as AnyObject) {
            self.image = cachedImage
            return
        }
        
        // Le téléchargement et la mise à jour de l'image se fait de façon asynchrone
        DispatchQueue.global().async { [weak self] in
            if let imageData = try? Data(contentsOf: imageURL) {
                if let image = UIImage(data: imageData) {
                    // Le changement d'image après téléchargement doit se faire dans le main thread
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
