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
}

final class HomeViewModel {
    weak var view: HomeViewInterface?
}

extension HomeViewModel: HomeViewModelInterface {
    func viewDidLoad() {
        view?.setUIForSearch()
        view?.setDelegateUI()
    }
}
