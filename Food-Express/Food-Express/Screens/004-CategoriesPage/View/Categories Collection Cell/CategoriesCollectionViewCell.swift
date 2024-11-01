//
//  CategoriesCollectionViewCell.swift
//  Food-Express
//
//  Created by erkut on 8.10.2024.
//

import UIKit

protocol CategoriesCellInterface {
    func setUpCell(name item: String, image item2: String)
    static var id: String { get }
    static func register() -> UINib
}

final class CategoriesCollectionViewCell: UICollectionViewCell {

    @IBOutlet private weak var categoryImageView: UIImageView!
    @IBOutlet private weak var categoryNameLbl: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = 16
    }
}

extension CategoriesCollectionViewCell: CategoriesCellInterface {
    static var id: String {
        return String(describing: self)
    }

    static func register() -> UINib {
        UINib(nibName: String(describing: self), bundle: nil)
    }

    func setUpCell(name item: String, image item2: String) {
        self.categoryNameLbl.text = item
        self.categoryImageView.image = UIImage(named: item2)
    }
}
