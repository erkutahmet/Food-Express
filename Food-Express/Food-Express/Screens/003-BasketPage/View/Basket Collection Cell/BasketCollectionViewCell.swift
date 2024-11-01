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
    func setupCellUI()
}

final class BasketCollectionViewCell: UICollectionViewCell {

    @IBOutlet private weak var basketProductImageView: UIImageView!
    @IBOutlet private weak var basketProductNameLbl: UILabel!
    @IBOutlet private weak var basketProductPriceLbl: UILabel!
    @IBOutlet private weak var basketProductAmountLbl: UILabel!
    @IBOutlet private weak var totalPriceLbl: UILabel!
    @IBOutlet private weak var basketProductView: UIView!
    @IBOutlet private weak var deleteView: UIView!

    weak var delegate: BasketCollectionViewDelegate?

    @IBAction private func deleteBtnClicked(_ sender: Any) {
        delegate?.didRequestDelete(self)
    }
}

extension BasketCollectionViewCell: BasketCollectionViewCellInterface {

    static var identifier: String {
        return String(describing: self)
    }

    static func register() -> UINib {
        UINib(nibName: String(describing: self), bundle: nil)
    }

    func setupCell(viewModel: ViewBasketModel) {
        self.basketProductNameLbl.text = viewModel.yemekAdi
        self.basketProductPriceLbl.text = "\(viewModel.yemekFiyat)₺"
        self.basketProductAmountLbl.text = viewModel.yemekSiparisAdet
        self.basketProductImageView.af.setImage(withURL: viewModel.imageURL)
        self.totalPriceLbl.text = "\((Int(viewModel.yemekFiyat) ?? 1) * (Int(viewModel.yemekSiparisAdet) ?? 1))₺"
    }

    func setupCellUI() {
        basketProductView.layer.cornerRadius = 16
        basketProductView.layer.borderWidth = 2
        basketProductView.layer.borderColor = UIColor.label.cgColor

        deleteView.layer.cornerRadius = 16
    }

    func animateRemoval() {
        UIView.animate(withDuration: 0.5, delay: 0.1, animations: {
            self.transform = CGAffineTransform(translationX: -self.frame.width, y: 0)
            self.alpha = 0
        })
    }
}
