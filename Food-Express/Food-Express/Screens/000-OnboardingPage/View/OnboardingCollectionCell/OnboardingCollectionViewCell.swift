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
}

final class OnboardingCollectionViewCell: UICollectionViewCell {

    @IBOutlet private weak var onboardingAnimView: UIView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var contentLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
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
        
        titleLabel.text = slide.title
        contentLabel.text = slide.description
    }
}
