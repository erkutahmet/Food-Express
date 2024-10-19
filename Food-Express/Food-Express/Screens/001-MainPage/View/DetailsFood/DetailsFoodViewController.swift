//
//  DetailsFoodViewController.swift
//  Food-Express
//
//  Created by erkut on 10.10.2024.
//

import UIKit
import AlamofireImage

protocol DetailsViewInterface: AnyObject {
    func configResult()
    func getParameters() -> AddFoodBasketParameters
}

final class DetailsFoodViewController: UIViewController {
    
    private let foodViewModel: FoodViewModel
    
    @IBOutlet private weak var foodNameLbl: UILabel!
    @IBOutlet private weak var foodPriceLbl: UILabel!
    @IBOutlet private weak var foodImageView: UIImageView!
    @IBOutlet private weak var amountLbl: UILabel!
    @IBOutlet private weak var favoriteBtn: UIButton!
    private lazy var viewModel = DetailsViewModel()
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
    
    @IBAction private func favoriteBtnClicked(_ sender: Any) {
        if favoriteBtn.currentImage == UIImage(named: "favorite_unclicked") {
            favoriteBtn.setImage(UIImage(named: "favorite"), for: .normal)
        } else {
            favoriteBtn.setImage(UIImage(named: "favorite_unclicked"), for: .normal)
        }
    }
    
    @IBAction private func addToBasketBtnClicked(_ sender: Any) {
        viewModel.addFoodToBasket(parameters: getParameters())
    }

    @IBAction private func minusBtnClicked(_ sender: Any) {
        if amount > 1 {
            amount -= 1
            amountLbl.text = String(amount)
            foodPriceLbl.text = String((Int(foodViewModel.yemekFiyat) ?? 1) * amount)
        }
    }

    @IBAction private func plusBtnClicked(_ sender: Any) {
        amount += 1
        amountLbl.text = String(amount)
        foodPriceLbl.text = String((Int(foodViewModel.yemekFiyat) ?? 1) * amount)
    }
}

extension DetailsFoodViewController: DetailsViewInterface {
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
}
