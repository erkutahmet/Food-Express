//
//  CategoriesPageViewModel.swift
//  Food-Express
//
//  Created by erkut on 17.10.2024.
//

import Foundation

protocol CategoriesPageViewModelInterface {
    var view: CategoriesViewInterface? { get set }

    func viewDidLoad()
    func numberOfItems() -> Int
    func cellForItem(at indexPath: IndexPath) -> (String, String)
}

final class CategoriesPageViewModel {
    weak var view: CategoriesViewInterface?
    private let categoryList = ["Appetizers", "Salad", "Soup", "Seafood", "Beef", "Pasta", "Burger", "Pizza"]
    private let categoryListImage = ["appetizers", "salad", "soup", "seafood", "beef", "pasta", "burger", "pizza"]
}

extension CategoriesPageViewModel: CategoriesPageViewModelInterface {
    func viewDidLoad() {
        view?.prepareCollectionView()
    }

    func numberOfItems() -> Int {
        categoryList.count
    }

    func cellForItem(at indexPath: IndexPath) -> (String, String) {
        return (categoryList[indexPath.item], categoryListImage[indexPath.item])
    }
}
