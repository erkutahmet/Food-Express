//
//  OverLayerPopUpViewController.swift
//  Food-Express
//
//  Created by erkut on 23.10.2024.
//

import UIKit

enum PopUpType {
    case favorite
    case addToBasket
    case placeOrder
}

protocol OverLayerPopUpInterface {
    func appear(sender: UIViewController, popUpType: PopUpType)
}

final class OverLayerPopUpViewController: UIViewController {

    @IBOutlet private weak var backView: UIView!
    @IBOutlet private weak var contentView: UIView!
    @IBOutlet private weak var symbolImageView: UIImageView!
    @IBOutlet private weak var messageLabel: UILabel!
    
    @IBOutlet weak var symbolImageViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var symbolImageViewWidthConstraint: NSLayoutConstraint!

    private var popUpType: PopUpType?
    
    init() {
        super.init(nibName: "OverLayerPopUpViewController", bundle: nil)
        self.modalPresentationStyle = .overFullScreen
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
    }

    override func viewDidAppear(_ animated: Bool) {
        updateUIForPopUpType()
    }

    private func configView() {
        self.view.backgroundColor = .clear
        self.backView.backgroundColor = .black.withAlphaComponent(0.4)
        self.backView.alpha = 0
        self.contentView.layer.cornerRadius = 20
    }

    private func updateUIForPopUpType() {
        guard let popUpType = popUpType else { return }
        
        switch popUpType {
        case .favorite:
            symbolImageViewWidthConstraint.constant = 48
            symbolImageViewHeightConstraint.constant = 48
            symbolImageView.image = UIImage(systemName: "heart")
            symbolImageView.tintColor = .darkGray
            messageLabel.text = "Great! The item has been added to your favorites. You can visit your favorites anytime you like."
            
        case .addToBasket:
            symbolImageViewWidthConstraint.constant = 48
            symbolImageViewHeightConstraint.constant = 48
            symbolImageView.image = UIImage(systemName: "info.circle")
            symbolImageView.tintColor = .lightGray
            messageLabel.text = "Great choice! If you'd like to proceed with the item in your cart, you can complete your order."
        
        case .placeOrder:
            symbolImageViewWidthConstraint.constant = 120
            symbolImageViewHeightConstraint.constant = 120
            symbolImageView.image = UIImage(systemName: "checkmark.circle")
            symbolImageView.tintColor = .darkGray
            messageLabel.text = "Your order has been confirmed and is being prepared for delivery. Thank you for your understanding."
        }
    }

    private func show() {
        UIView.animate(withDuration: 0.5, delay: 0.1) {
            self.backView.alpha = 1
            self.contentView.alpha = 1
            UIView.animate(withDuration: 0.5, delay: 0.5) {
                self.animateIconForPopUpType()
            }
        }
    }
    
    private func standartIconForPopUpType() {
        guard let popUpType = popUpType else { return }
        
        switch popUpType {
        case .favorite:
            symbolImageView.image = UIImage(systemName: "heart")
            symbolImageView.tintColor = .darkGray
            
        case .addToBasket:
            symbolImageView.image = UIImage(systemName: "info.circle")
            symbolImageView.tintColor = .lightGray
            
        case .placeOrder:
            symbolImageView.tintColor = .darkGray
        }
    }
    
    private func animateIconForPopUpType() {
        guard let popUpType = popUpType else { return }
        
        switch popUpType {
        case .favorite:
            self.symbolImageView.image = UIImage(systemName: "heart.fill")
            self.symbolImageView.tintColor = .red
            
        case .addToBasket:
            self.symbolImageView.image = UIImage(systemName: "info.circle.fill")
            self.symbolImageView.tintColor = .darkGray
            
        case .placeOrder:
            self.symbolImageView.tintColor = .green
        }
    }

    private func hide() {
        UIView.animate(withDuration: 1, delay: 0.0, options: .curveEaseOut) {
            self.backView.alpha = 0
            self.contentView.alpha = 0
        } completion: { _ in
            self.dismiss(animated: false)
            self.removeFromParent()
        }
    }
}

extension OverLayerPopUpViewController: OverLayerPopUpInterface {
    func appear(sender: UIViewController, popUpType: PopUpType) {
        self.popUpType = popUpType
        sender.present(self, animated: false) {
            self.show()
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                self.hide()
            }
        }
    }
}
