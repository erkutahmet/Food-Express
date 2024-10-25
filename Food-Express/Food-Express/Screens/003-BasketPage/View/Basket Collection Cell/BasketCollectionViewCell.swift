//
//  BasketCollectionViewCell.swift
//  Food-Express
//
//  Created by erkut on 8.10.2024.
//

import UIKit
import AlamofireImage

protocol BasketCollectionViewDelegate: AnyObject {
    func didRequestDelete(_ cell: BasketCollectionViewCell)
}

protocol BasketCollectionViewCellInterface {
    func setupCell(viewModel: ViewBasketModel)
    static var identifier: String { get }
    static func register() -> UINib
    func animateRemoval()
}

final class BasketCollectionViewCell: UICollectionViewCell {

    @IBOutlet private weak var basketProductImageView: UIImageView!
    @IBOutlet private weak var basketProductNameLbl: UILabel!
    @IBOutlet private weak var basketProductPriceLbl: UILabel!
    @IBOutlet private weak var basketProductAmountLbl: UILabel!
    @IBOutlet private weak var totalPriceLbl: UILabel!
    
    weak var delegate: BasketCollectionViewDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBAction private func deleteBtnClicked(_ sender: Any) {
        delegate?.didRequestDelete(self)
    }
}

extension BasketCollectionViewCell: BasketCollectionViewCellInterface {
    static var identifier: String {
        return "basketCell"
    }
    
    static func register() -> UINib {
        UINib(nibName: "BasketCollectionViewCell", bundle: nil)
    }

    func setupCell(viewModel: ViewBasketModel) {
        self.basketProductNameLbl.text = viewModel.yemekAdi
        self.basketProductPriceLbl.text = "\(viewModel.yemekFiyat)₺"
        self.basketProductAmountLbl.text = viewModel.yemekSiparisAdet
        self.basketProductImageView.af.setImage(withURL: viewModel.imageURL)
        self.totalPriceLbl.text = "\((Int(viewModel.yemekFiyat) ?? 1) * (Int(viewModel.yemekSiparisAdet) ?? 1))₺"
    }

    func animateRemoval() {
        UIView.animate(withDuration: 0.5, delay: 0.1, animations: {
            self.transform = CGAffineTransform(translationX: -self.frame.width, y: 0)
            self.alpha = 0
        })
    }
}
