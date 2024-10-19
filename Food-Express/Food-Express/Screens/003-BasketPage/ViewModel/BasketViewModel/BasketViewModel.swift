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
}

final class BasketViewModel {
    weak var view: BasketPageViewInterface?
}

extension BasketViewModel: BasketViewModelInterface {

    func viewDidLoad() {
        view?.setUIDesign()
        view?.setDelegateUI()
    }
}
