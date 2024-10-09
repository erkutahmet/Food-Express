//
//  HomeViewModel.swift
//  Food-Express
//
//  Created by erkut on 7.10.2024.
//

import Foundation

protocol HomeViewModelInterface {
    var view: HomeViewInterface? { get set }

    func viewDidLoad()
    func viewWillAppear()
    func getData()
}

final class HomeViewModel {
    weak var view: HomeViewInterface?
}

extension HomeViewModel: HomeViewModelInterface {
    func viewDidLoad() {
        view?.setUIForSearch()
        view?.setDelegateUI()
    }

    func viewWillAppear() {
        view?.setDarkModeUI()
    }

    func getData() {
        APICaller.getFoods { result in
            switch result {
            case .success(let foods):
                print("Yemek adi: \(foods.yemekler?.last?.yemekAdi ?? "")")
                print("Yemek resim: \(foods.yemekler?.last?.yemekResimAdi ?? "")")
                print("Yemek fiyat: \(foods.yemekler?.last?.yemekFiyat ?? "")")
                print("Yemek yemekID: \(foods.yemekler?.last?.yemekID ?? "")")
            case .failure(let error):
                    print("This error -> \(error)")
            }
        }
    }
}
