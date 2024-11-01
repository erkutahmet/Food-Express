//
//  BasketPageViewModel.swift
//  Food-Express
//
//  Created by erkut on 18.10.2024.
//

import Foundation

protocol BasketViewModelInterface {
    var view: BasketPageViewInterface? { get set }

    func viewDidLoad()
    func viewWillAppear()
    func getFoodsInBasket()
    func mapCellData()
    func getTotalPrice() -> Double
    func removeItem(at indexPath: IndexPath)
}

final class BasketViewModel {
    weak var view: BasketPageViewInterface?
    var dataSource: BasketModel?
    var cellDataSource: Observable<[ViewBasketModel]> = Observable(nil)
}

extension BasketViewModel: BasketViewModelInterface {

    func viewDidLoad() {
        view?.setUIDesign()
        view?.setDelegateUI()
        view?.bindViewModel()
    }

    func viewWillAppear() {
        getFoodsInBasket()
        view?.reloadData()
    }

    func getTotalPrice() -> Double {
        let totalPrice = dataSource?.sepet_yemekler?.reduce(0.0) { (result, item) -> Double in
            let amount = Int(item.yemek_siparis_adet ?? "0") ?? 0
            let price = Double(item.yemek_fiyat ?? "0") ?? 0
            return result + (Double(amount) * price)
        }
        return totalPrice ?? 0.0
    }

    func getFoodsInBasket() {
        APICaller.getFoodInBasket { [weak self] result in
            switch result {
            case .success(let data):
                self?.dataSource = data
                self?.mapCellData()
            case .failure:
                self?.cellDataSource.value = []
                self?.view?.showAlertFromVM(title: "Warning!",
                                            message: "Your cart is empty. There is nothing to display here.")
                print("Error from -> (getFoodsInBasket)")
            }
        }
    }

    func removeItem(at indexPath: IndexPath) {
        guard let id = self.cellDataSource.value?[indexPath.item].sepetYemekID else { return }
        let parameterID = DeleteFoodBasketParameters(sepetYemekID: id)
        APICaller.deleteFoodFromBasket(parameters: parameterID) { [weak self] result in

            guard let self = self else { return }

            switch result {
            case .success(let data):
                if data.success == 0 {
                    print("Deletion failed \(id)")
                    self.view?.showAlertFromVM(title: "Error!",
                                               message: "An unexpected error occurred during the deletion process.")
                } else {
                    print("Deletion succeed.")
                    self.view?.animateRemoval(at: indexPath)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                        self.getFoodsInBasket()
                    }
                }
            case .failure:
                self.view?.showAlertFromVM(title: "Error!",
                                           message: "An unexpected error occurred during the deletion process.")
                print("Error from (deleteFoodFromBasket)")
            }
        }
    }

    func mapCellData() {
        self.cellDataSource.value = self.dataSource?.sepet_yemekler?.compactMap({ViewBasketModel(basket: $0)}) ?? []
    }
}
