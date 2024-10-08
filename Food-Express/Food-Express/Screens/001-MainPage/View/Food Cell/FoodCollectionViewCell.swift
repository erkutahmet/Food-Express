//
//  FoodCollectionViewCell.swift
//  Food-Express
//
//  Created by erkut on 7.10.2024.
//

import UIKit

class FoodCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var foodImageView: UIImageView!
    @IBOutlet weak var foodNameLbl: UILabel!
    @IBOutlet weak var foodPriceLbl: UILabel!
    @IBOutlet weak var priceSymbolLbl: UILabel!
    @IBOutlet weak var foodBackView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
