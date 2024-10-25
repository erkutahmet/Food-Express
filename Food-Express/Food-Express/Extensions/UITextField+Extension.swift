//
//  UITextField+Extension.swift
//  Food-Express
//
//  Created by erkut on 24.10.2024.
//

import UIKit

extension UITextField {
    func setPlaceholder(_ text: String, color: UIColor = .lightGray) {
        self.attributedPlaceholder = NSAttributedString(string: text, attributes: [.foregroundColor: color])
    }
}
