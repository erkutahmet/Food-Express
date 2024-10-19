//
//  DetailsFoodViewController.swift
//  Food-Express
//
//  Created by erkut on 10.10.2024.
//

import UIKit
import AlamofireImage

final class DetailsFoodViewController: UIViewController {
    
    private let viewModel: FoodViewModel
    
    @IBOutlet private weak var foodNameLbl: UILabel!
    @IBOutlet private weak var foodPriceLbl: UILabel!
    @IBOutlet private weak var foodImageView: UIImageView!
    @IBOutlet private weak var amountLbl: UILabel!
    @IBOutlet private weak var favoriteBtn: UIButton!

    private var amount = 1

    init(viewModel: FoodViewModel) {
        self.viewModel = viewModel
        super.init(nibName: "DetailsFoodViewController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configResult()
    }
    
    func configResult() {
        foodNameLbl.text = viewModel.yemekAdi
        foodPriceLbl.text = viewModel.yemekFiyat
        foodImageView.af.setImage(withURL: viewModel.imageURL)
    }
    @IBAction private func favoriteBtnClicked(_ sender: Any) {
        if favoriteBtn.currentImage == UIImage(named: "favorite_unclicked") {
            favoriteBtn.setImage(UIImage(named: "favorite"), for: .normal)
        } else {
            favoriteBtn.setImage(UIImage(named: "favorite_unclicked"), for: .normal)
        }
    }
    
    @IBAction private func addToBasketBtnClicked(_ sender: Any) {
        APICaller.addFoodToBasket(ad: viewModel.yemekAdi, resim: viewModel.yemekResimAdi, fiyat: viewModel.yemekFiyat, adet: String(amount)) { result in
            switch result {
            case .success(let data):
                if data.success == 0 {
                    // TODO: buraya alert
                    print("Sepete ekleme işlemi başarısız")
                } else {
                    print("Sepete ekleme işlemi başarılı")
                    self.navigationController?.popViewController(animated: true)
                }
            case .failure:
                print("Error from (addFoodToBasket)")
            }
        }
    }

    @IBAction private func minusBtnClicked(_ sender: Any) {
        if amount > 1 {
            amount -= 1
            amountLbl.text = String(amount)
            foodPriceLbl.text = String((Int(viewModel.yemekFiyat) ?? 1) * amount)
        }
    }
    @IBAction private func plusBtnClicked(_ sender: Any) {
        amount += 1
        amountLbl.text = String(amount)
        foodPriceLbl.text = String((Int(viewModel.yemekFiyat) ?? 1) * amount)
    }
}
