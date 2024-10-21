//
//  DetailsViewModel.swift
//  Food-Express
//
//  Created by erkut on 19.10.2024.
//

import Foundation

protocol DetailsViewModelInterface {
    var view: DetailsViewInterface? { get set }
    
    func viewDidLoad()
    func addFoodToBasket(parameters: AddFoodBasketParameters)
}

final class DetailsViewModel {
    weak var view: DetailsViewInterface?
}

extension DetailsViewModel: DetailsViewModelInterface {
    
    func viewDidLoad() {
        view?.configResult()
    }

    func addFoodToBasket(parameters: AddFoodBasketParameters) {
        APICaller.addFoodToBasket(parameters: parameters) { [weak self] result in
            
            guard let self = self else { return }

            switch result {
            case .success(let data):
                if data.success == 0 {
                    self.view?.showAlert(status: false, title: "Failed", message: "Your product could not be added to the basket due to an unknown reason.")
                    print("Adding to basket failed")
                } else {
                    self.view?.showAlert(status: true, title: "Added to Basket", message: "Your product has been successfully added to the basket.")
                    print("Adding to basket successful")
                }
            case .failure:
                print("Error from (addFoodToBasket)")
            }
        }
    }
}
