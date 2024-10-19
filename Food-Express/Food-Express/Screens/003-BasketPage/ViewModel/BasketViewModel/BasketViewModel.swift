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
        getFoodsInBasket()
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
        APICaller.getFoodInBasket() { result in
            switch result {
            case .success(let data):
                self.dataSource = data
                self.mapCellData()
            case .failure:
                self.cellDataSource.value = []
                print("Error from -> (getFoodsInBasket)")
            }
        }
    }

    func removeItem(at indexPath: IndexPath) {
        guard let id = self.cellDataSource.value?[indexPath.item].sepetYemekID else { return }
        APICaller.deleteFoodFromBasket(id: id) { result in
            switch result {
            case .success(let data):
                if data.success == 0 {
                    print("başarısız \(id)")
                } else {
                    print("başarılı")
                    self.getFoodsInBasket()
                }
            case .failure:
                print("Error from (deleteFoodFromBasket)")
            }
        }
    }

    func mapCellData() {
        self.cellDataSource.value = self.dataSource?.sepet_yemekler?.compactMap( {ViewBasketModel(basket: $0)} ) ?? []
    }
}
