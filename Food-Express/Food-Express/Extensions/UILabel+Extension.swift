//
//  UILabel+Extension.swift
//  Food-Express
//
//  Created by erkut on 24.10.2024.
//

import UIKit

extension UILabel {
    func setHTML(from html: String) {
        guard let data = html.data(using: .utf8) else { return }
        
        do {
            let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
                .documentType: NSAttributedString.DocumentType.html,
                .characterEncoding: String.Encoding.utf8.rawValue
            ]
            
            let attributedString = try NSMutableAttributedString(data: data, options: options, documentAttributes: nil)
            
            let textColor = UIColor.label

            attributedString.addAttribute(.foregroundColor, value: textColor, range: NSRange(location: 0, length: attributedString.length))
            
            self.attributedText = attributedString
        } catch {
            print("Error creating attributed string: \(error)")
        }
    }
}

