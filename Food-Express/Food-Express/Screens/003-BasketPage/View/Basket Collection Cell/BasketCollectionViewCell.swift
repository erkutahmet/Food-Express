//
//  BasketCollectionViewCell.swift
//  Food-Express
//
//  Created by erkut on 8.10.2024.
//

import UIKit

protocol BasketCollectionViewDelegate: AnyObject {
    func didUpdateAmount(for cell: BasketCollectionViewCell)
    func didRequestDelete(_ cell: BasketCollectionViewCell)
}

final class BasketCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var basketProductImageView: UIImageView!
    @IBOutlet weak var basketProductNameLbl: UILabel!
    @IBOutlet weak var basketProductPriceLbl: UILabel!
    @IBOutlet weak var basketProductAmountLbl: UILabel!
    @IBOutlet weak var increaseImageView: UIImageView!
    @IBOutlet weak var decreaseImageView: UIImageView!
    
    var amount: Int = 1
    var price: Double = 0.0
    weak var delegate: BasketCollectionViewDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        
        let increaseTapGesture = UITapGestureRecognizer(target: self, action: #selector(increaseAmount))
        increaseImageView.isUserInteractionEnabled = true
        increaseImageView.addGestureRecognizer(increaseTapGesture)

        let decreaseTapGesture = UITapGestureRecognizer(target: self, action: #selector(decreaseAmount))
        decreaseImageView.isUserInteractionEnabled = true
        decreaseImageView.addGestureRecognizer(decreaseTapGesture)

        updateDecreaseImageView()
        updateTotalPrice()
    }

    func configure(amount: Int, price: Double) {
        self.amount = amount
        self.price = price
        basketProductAmountLbl.text = String(amount)
        updateDecreaseImageView()
        updateTotalPrice()
    }

    @objc private func increaseAmount() {
        if amount >= 1 {
            amount += 1
            basketProductAmountLbl.text = String(amount)
            updateDecreaseImageView()
            updateTotalPrice()
            delegate?.didUpdateAmount(for: self)
        }
    }

    @objc private func decreaseAmount() {
        if amount > 1 {
            amount -= 1
            basketProductAmountLbl.text = String(amount)
            updateDecreaseImageView()
            updateTotalPrice()
            delegate?.didUpdateAmount(for: self)
        } else {
            delegate?.didRequestDelete(self)
        }
    }

    private func updateDecreaseImageView() {
        if amount == 1 {
            decreaseImageView.image = UIImage(systemName: "trash.circle")
            decreaseImageView.tintColor = .systemRed
        } else {
            decreaseImageView.image = UIImage(systemName: "minus.circle")
            decreaseImageView.tintColor = .black
        }
    }

    private func updateTotalPrice() {
        let totalPrice = Double(amount) * price
        basketProductPriceLbl.text = String(format: "%.2f₺", totalPrice)
    }
}

