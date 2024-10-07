//
//  FavoriteTableViewCell.swift
//  Food-Express
//
//  Created by erkut on 7.10.2024.
//

import UIKit

final class FavoriteTableViewCell: UITableViewCell {

    @IBOutlet weak var favoriteImageView: UIImageView!
    @IBOutlet weak var favoriteNameLbl: UILabel!
    @IBOutlet weak var favoriteHeartImageView: UIImageView!
    @IBOutlet weak var favoriteInfoLbl: UILabel!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var backGroundBlurView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUI()
    }

    private func setUI() {
        favoriteImageView.layer.cornerRadius = 16
        favoriteImageView.layer.maskedCorners = [ .layerMinXMinYCorner, .layerMaxXMinYCorner ]

        bottomView.layer.cornerRadius = 16
        bottomView.layer.maskedCorners = [ .layerMinXMaxYCorner, .layerMaxXMaxYCorner ]

        backGroundBlurView.layer.cornerRadius = 16

        favoriteHeartImageView.image = UIImage(systemName: "heart")
        favoriteHeartImageView.tintColor = .black
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
