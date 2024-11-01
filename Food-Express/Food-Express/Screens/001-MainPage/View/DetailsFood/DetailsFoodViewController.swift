//
//  DetailsFoodViewController.swift
//  Food-Express
//
//  Created by erkut on 10.10.2024.
//

import UIKit
import AlamofireImage

protocol DetailsViewInterface: AnyObject {
    func setUI()
    func configResult()
    func getParameters() -> AddFoodBasketParameters
    func showAlert(status: Bool, title: String, message: String)
    func showPopUp(at popUpType: PopUpType)
    func updateLikeButton(isLiked: Bool)
    func setFavoriteBtnUI()
}

final class DetailsFoodViewController: UIViewController {

    private let foodViewModel: FoodViewModel

    @IBOutlet private weak var foodNameLbl: UILabel!
    @IBOutlet private weak var foodPriceLbl: UILabel!
    @IBOutlet private weak var foodImageView: UIImageView!
    @IBOutlet private weak var amountLbl: UILabel!
    @IBOutlet private weak var favoriteBtn: UIButton!
    @IBOutlet private weak var addToBasketBtn: UIButton!
    @IBOutlet private weak var plusBtn: UIButton!
    @IBOutlet private weak var minusBtn: UIButton!

    private lazy var viewModel = DetailsViewModel()
    private lazy var overLayer = OverLayerPopUpViewController()

    private var amount = 1

    init(foodViewModel: FoodViewModel) {
        self.foodViewModel = foodViewModel
        super.init(nibName: "DetailsFoodViewController", bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.view = self
        viewModel.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.viewWillAppear()
    }

    @IBAction private func favoriteBtnClicked(_ sender: Any) {
        if !viewModel.isLiked {
            favoriteBtn.setImage(UIImage(named: "favorite_clicked"), for: .normal)
            viewModel.addToFavorite(newFavorite: Favorites(food_name: foodViewModel.yemekAdi,
                                                           food_image: foodViewModel.yemekResimAdi))
        } else {
            favoriteBtn.setImage(UIImage(named: "favorite_unclicked"), for: .normal)
            viewModel.deleteFromFavorite(foodName: foodViewModel.yemekAdi)
        }
    }

    @IBAction private func addToBasketBtnClicked(_ sender: UIButton) {
        viewModel.addFoodToBasket(parameters: getParameters())
        sender.disableTemporarilyWithTapEffect()
    }

    @IBAction private func minusBtnClicked(_ sender: UIButton) {
        if amount > 1 {
            amount -= 1
            amountLbl.text = String(amount)
            foodPriceLbl.text = String((Int(foodViewModel.yemekFiyat) ?? 1) * amount)
            sender.changeButtonImageTemporarily(normalImageName: "minus", clickedImageName: "minusClicked")
        }
    }

    @IBAction private func plusBtnClicked(_ sender: UIButton) {
        amount += 1
        amountLbl.text = String(amount)
        foodPriceLbl.text = String((Int(foodViewModel.yemekFiyat) ?? 1) * amount)
        sender.changeButtonImageTemporarily(normalImageName: "plus", clickedImageName: "plusClicked")
    }
}

extension DetailsFoodViewController: DetailsViewInterface {
    func setUI() {
        addToBasketBtn.layer.cornerRadius = 16
        addToBasketBtn.layer.maskedCorners = [ .layerMinXMinYCorner, .layerMaxXMaxYCorner]
        addToBasketBtn.layer.borderColor = UIColor(hex: "#808080").cgColor
        addToBasketBtn.layer.borderWidth = 1.0
    }

    func setFavoriteBtnUI() {
        viewModel.isFavorite(foodName: foodViewModel.yemekAdi)
    }

    func updateLikeButton(isLiked: Bool) {
        if isLiked {
            favoriteBtn.setImage(UIImage(named: "favorite_clicked"), for: .normal)
        } else {
            favoriteBtn.setImage(UIImage(named: "favorite_unclicked"), for: .normal)
        }
    }

    func configResult() {
        foodNameLbl.text = foodViewModel.yemekAdi
        foodPriceLbl.text = foodViewModel.yemekFiyat
        foodImageView.af.setImage(withURL: foodViewModel.imageURL)
    }

    func getParameters() -> AddFoodBasketParameters {
        AddFoodBasketParameters(yemekAdi: foodViewModel.yemekAdi,
                          yemekResimAdi: foodViewModel.yemekResimAdi,
                          yemekFiyat: foodViewModel.yemekFiyat,
                          yemekSiparisAdet: String(amount))
    }

    func showAlert(status: Bool, title: String, message: String) {
        if status {
            successShowAlert(title: title, message: message)
        } else {
            errorShowAlert(title: title, message: message)
        }
    }

    func showPopUp(at popUpType: PopUpType) {
        switch popUpType {
        case .addToBasket:
            overLayer.appear(sender: self, popUpType: .addToBasket)
        case .favorite:
            overLayer.appear(sender: self, popUpType: .favorite)
        case .placeOrder:
            break
        }
    }
}
