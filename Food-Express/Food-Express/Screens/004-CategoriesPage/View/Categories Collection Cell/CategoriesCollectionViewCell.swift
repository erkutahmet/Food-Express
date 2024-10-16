//
//  CategoriesCollectionViewCell.swift
//  Food-Express
//
//  Created by erkut on 8.10.2024.
//

import UIKit

protocol CategoriesCellInterface {
    func setUpCell(item: String)
    static var identifier: String { get }
    static func register() -> UINib
}

class CategoriesCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var categoryImageView: UIImageView!
    @IBOutlet weak var categoryNameLbl: UILabel!

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

    func setUpCell(item: String) {
        self.categoryNameLbl.text = item
        self.categoryImageView.image = UIImage(named: item)
    }
}
