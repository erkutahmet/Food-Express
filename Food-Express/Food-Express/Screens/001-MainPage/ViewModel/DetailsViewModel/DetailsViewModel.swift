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
        APICaller.addFoodToBasket(parameters: parameters) { result in
            switch result {
            case .success(let data):
                if data.success == 0 {
                    // TODO: buraya alert
                    print("Sepete ekleme işlemi başarısız")
                } else {
                    print("Sepete ekleme işlemi başarılı")
                }
            case .failure:
                print("Error from (addFoodToBasket)")
            }
        }
    }
}
