//
//  FavoriteTableViewCell.swift
//  Food-Express
//
//  Created by erkut on 7.10.2024.
//

import UIKit

protocol FavoriteCellInterface {
    static var identifier: String { get }
    static func register() -> UINib
    func setupCell(viewModel: FavoritesModel, at indexPath: IndexPath)
    func setCellUI()
}

final class FavoriteTableViewCell: UITableViewCell {

    @IBOutlet private weak var favoriteImageView: UIImageView!
    @IBOutlet private weak var favoriteNameLbl: UILabel!
    @IBOutlet private weak var favoriteHeartImageView: UIImageView!
    @IBOutlet private weak var favoriteInfoLbl: UILabel!
    @IBOutlet private weak var bottomView: UIView!
    @IBOutlet private weak var favoritesContentView: UIView!
    @IBOutlet private weak var backGroundBlurView: UIView!

}

extension FavoriteTableViewCell: FavoriteCellInterface {
    static var identifier: String {
        return String(describing: self)
    }

    static func register() -> UINib {
        UINib(nibName: String(describing: self), bundle: nil)
    }

    func setupCell(viewModel: FavoritesModel, at indexPath: IndexPath) {
        self.favoriteNameLbl.text = viewModel.foodName
        self.favoriteImageView.af.setImage(withURL: viewModel.foodImageUrl)
        self.favoriteInfoLbl.text = FavoritesInfoConstants.favoriteDescriptions[indexPath.row]
    }

    func setCellUI() {
        favoriteImageView.layer.cornerRadius = 16
        favoriteImageView.layer.masksToBounds = true

        bottomView.layer.cornerRadius = 16
        bottomView.layer.maskedCorners = [ .layerMinXMaxYCorner, .layerMaxXMaxYCorner ]
        bottomView.layer.borderWidth = 1
        bottomView.layer.borderColor = UIColor(named: "darkModeSpecialReverse")?.cgColor
        bottomView.layer.masksToBounds = true

        backGroundBlurView.layer.cornerRadius = 16

        favoritesContentView.layer.cornerRadius = 16
        favoritesContentView.layer.borderWidth = 2
        favoritesContentView.layer.borderColor = UIColor(named: "darkModeSpecialReverse")?.cgColor

        favoriteHeartImageView.image = UIImage(systemName: "heart.fill")
        favoriteHeartImageView.tintColor = .systemRed
    }
}
