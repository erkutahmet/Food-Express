//
//  FoodCollectionViewCell.swift
//  Food-Express
//
//  Created by erkut on 7.10.2024.
//

import UIKit
import AlamofireImage

protocol FoodCellInterface {
    func setupCell(viewModel: FoodViewModel)
    static var identifier: String { get }
    static func register() -> UINib
}

final class FoodCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var foodImageView: UIImageView!
    @IBOutlet weak var foodInfoLbl: UILabel!
    @IBOutlet weak var foodBackView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
    }
}

extension FoodCollectionViewCell: FoodCellInterface {
    static var identifier: String {
        return "foodCell"
    }
    
    static func register() -> UINib {
        UINib(nibName: "FoodCollectionViewCell", bundle: nil)
    }
    
    func setupCell(viewModel: FoodViewModel) {
        self.foodInfoLbl.text = "\(viewModel.yemekAdi)\n\(viewModel.yemekFiyat)₺"
        self.foodImageView.af.setImage(withURL: viewModel.imageURL)
    }

    func setupCellShadowView(index: Int) {
        self.foodBackView.backgroundColor = FoodCellColors.backgroundColors[(index % 6)].color
        self.foodInfoLbl.textColor = FoodCellColors.tintColors[(index % 6)].color
        self.foodInfoLbl.shadowColor = FoodCellColors.shadowColors[(index % 6)].color
        self.backgroundColor = FoodCellColors.tintColors[(index % 6)].color
    }
}
