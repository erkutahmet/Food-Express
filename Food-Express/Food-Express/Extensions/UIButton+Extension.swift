//
//  UIButton+Extension.swift
//  Food-Express
//
//  Created by erkut on 25.10.2024.
//

import UIKit

extension UIButton {
    func disableTemporarilyWithTapEffect(duration: TimeInterval = 0.5) {
        guard isEnabled else { return }
        isEnabled = false

        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            self.isEnabled = true
        }
    }

    func changeButtonImageTemporarily(normalImageName: String, clickedImageName: String, duration: TimeInterval = 0.1) {
        let normalImage = UIImage(named: normalImageName)
        let clickedImage = UIImage(named: clickedImageName)
        setImage(clickedImage, for: .normal)
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            self.setImage(normalImage, for: .normal)
        }
    }
}
