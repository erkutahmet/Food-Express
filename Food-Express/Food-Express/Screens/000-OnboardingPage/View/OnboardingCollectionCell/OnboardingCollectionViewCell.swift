//
//  OnboardingCollectionViewCell.swift
//  Food-Express
//
//  Created by erkut on 29.10.2024.
//

import UIKit

protocol OnboardingCollectionViewCellInterface {
    static var identifier: String { get }
    static func register() -> UINib
    func setUp(_ slide: OnboardingModel)
    func blinkAnimation()
    func removeAllAnimations()
}

final class OnboardingCollectionViewCell: UICollectionViewCell {

    @IBOutlet private weak var onboardingImageView: UIImageView!
    @IBOutlet private weak var onboardingAnimView: UIView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var contentLabel: UILabel!

    override func prepareForReuse() {
        onboardingImageView.layer.removeAllAnimations()
        onboardingImageView.transform = .identity
    }
}

extension OnboardingCollectionViewCell: OnboardingCollectionViewCellInterface {
    static var identifier: String {
        return String(describing: self)
    }

    static func register() -> UINib {
        UINib(nibName: String(describing: self), bundle: nil)
    }

    func setUp(_ slide: OnboardingModel) {
        onboardingImageView.image = UIImage(named: slide.image)
        titleLabel.text = slide.title
        contentLabel.text = slide.description
    }

    func blinkAnimation() {
        UIView.animate(withDuration: 0.7,
                       delay: 0.5,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 0.5,
                       options: [.autoreverse, .repeat],
                       animations: {
            self.onboardingImageView.alpha = 1
            self.onboardingImageView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        }, completion: nil)
    }

    func removeAllAnimations() {
        self.onboardingImageView.layer.removeAllAnimations()
        self.onboardingImageView.transform = .identity
    }
}
