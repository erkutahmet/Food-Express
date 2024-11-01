//
//  FavoritesViewModel.swift
//  Food-Express
//
//  Created by erkut on 27.10.2024.
//

import Foundation

protocol FavoritesViewModelInterface {
    var view: FavoritesViewInterface? { get set }

    func viewDidLoad()
    func viewWillAppear()
    func getData()
    func deleteFavorite(foodName: String)
}

final class FavoritesViewModel {
    weak var view: FavoritesViewInterface?
    var favorites: Observable<[FavoritesModel]> = Observable(nil)
}

extension FavoritesViewModel: FavoritesViewModelInterface {
    func viewDidLoad() {
        view?.setUI()
    }

    func viewWillAppear() {
        getData()
        view?.bindViewModel()
    }

    func getData() {
        APICaller.fetchUserFavorites { [weak self] favorites, error in
            guard let self = self else { return }

            if let error = error {
                print("Failed to fetch favorites: \(error.localizedDescription)")
            } else if let favorites = favorites {
                self.favorites.value = favorites.map { FavoritesModel(favorite: $0)}
            }
        }
    }

    func deleteFavorite(foodName: String) {
        APICaller.deleteUserFavorite(foodName: foodName) { [weak self] error in
            guard let self = self else { return }

            if let error = error {
                self.view?.showAlert(status: false,
                                     title: "Failed",
                                     message: "Something went wrong while removing from favorites.")
                print("Failed to remove favorite: \(error.localizedDescription)")
            } else {
                self.getData()
                self.view?.showAlert(status: true,
                                     title: "Success",
                                     message: "Successfully removed from favorites.")
                print("Successfully removed from favorites.")
            }
        }
    }
}
