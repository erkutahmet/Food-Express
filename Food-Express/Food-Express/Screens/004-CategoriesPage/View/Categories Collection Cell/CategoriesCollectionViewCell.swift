//
//  CategoriesCollectionViewCell.swift
//  Food-Express
//
//  Created by erkut on 8.10.2024.
//

import UIKit

protocol CategoriesCellInterface {
    func setUpCell(name item: String, image item2: String)
    static var identifier: String { get }
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
    static var identifier: String {
        return "categoryCell"
    }
    
    static func register() -> UINib {
        UINib(nibName: "CategoriesCollectionViewCell", bundle: nil)
    }

    func setUpCell(name item: String, image item2: String) {
        self.categoryNameLbl.text = item
        self.categoryImageView.image = UIImage(named: item2)
    }
}
