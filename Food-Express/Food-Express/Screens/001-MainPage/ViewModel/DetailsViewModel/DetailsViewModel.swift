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
    func viewWillAppear()
    func addFoodToBasket(parameters: AddFoodBasketParameters)
    func addToFavorite(newFavorite: Favorites)
    func deleteFromFavorite(foodName: String)
    func isFavorite(foodName: String)
    func isFavoriteOrNot(foodName: String, favorites: [Favorites]) -> Bool
}

final class DetailsViewModel {
    weak var view: DetailsViewInterface?
    var isLiked = false
}

extension DetailsViewModel: DetailsViewModelInterface {
    
    func viewDidLoad() {
        view?.setUI()
        view?.configResult()
    }
    
    func viewWillAppear() {
        view?.setFavoriteBtnUI()
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
                    self.view?.showPopUp(at: .addToBasket)
                    print("Adding to basket successful")
                }
            case .failure:
                print("Error from (addFoodToBasket)")
            }
        }
    }

    func addToFavorite(newFavorite: Favorites) {
        APICaller.updateUserFavorites(newFavorite: newFavorite) { [ weak self ] error in
            
            guard let self = self else { return }
            
            if let error = error {
                self.view?.showAlert(status: false, title: "Failed", message: "Something went wrong while adding favorites.")
                print("Failed to update favorites: \(error.localizedDescription)")
            } else {
                self.view?.showPopUp(at: .favorite)
                print("Successfully added favorites!")
            }
        }
    }

    func deleteFromFavorite(foodName: String) {
        APICaller.deleteUserFavorite(foodName: foodName) { [ weak self ] error in
            
            guard let self = self else { return }
            
            if let error = error {
                self.view?.showAlert(status: false, title: "Failed", message: "Something went wrong while removing from favorites.")
                print("Failed to remove favorite: \(error.localizedDescription)")
            } else {
                self.view?.showAlert(status: false, title: "Success", message: "Successfully removed from favorites.")
                print("Successfully removed from favorites.")
            }
        }
    }
    
    func isFavorite(foodName: String) {
        APICaller.fetchUserFavorites { [ weak self ] favorites, error in
            
            guard let self = self else { return }
            
            if let error = error {
                print("Error fetching favorites: \(error)")
                return
            }
            
            guard let favorites = favorites else { return }
            
            isLiked = self.isFavoriteOrNot(foodName: foodName, favorites: favorites)
            view?.updateLikeButton(isLiked: isLiked)
        }
    }
    
    func isFavoriteOrNot(foodName: String, favorites: [Favorites]) -> Bool {
        return favorites.contains(where: { $0.food_name == foodName })
    }
}
