//
//  UIImageView+Extension.swift
//  Food-Express
//
//  Created by erkut on 8.10.2024.
//

import UIKit
import CoreImage

extension UIImageView {
    func addBlurWithRadius(blurRadius: CGFloat) {
        // Orijinal resmi al
        guard let image = self.image else { return }
        guard let ciImage = CIImage(image: image) else { return }
        
        // CIFilter ile Gaussian Blur uygulama
        let filter = CIFilter(name: "CIGaussianBlur")
        filter?.setValue(ciImage, forKey: kCIInputImageKey)
        filter?.setValue(blurRadius, forKey: kCIInputRadiusKey)
        
        // Filtrelenmiş resmi CIContext ile render et
        let context = CIContext(options: nil)
        if let output = filter?.outputImage,
           let cgImage = context.createCGImage(output, from: ciImage.extent) {
            self.image = UIImage(cgImage: cgImage)
        }
    }
}
