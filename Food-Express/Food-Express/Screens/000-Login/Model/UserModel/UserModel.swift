//
//  UserModel.swift
//  Food-Express
//
//  Created by erkut on 20.10.2024.
//

import Foundation

struct UserModel: Codable {
    var user_uuid: String?
    let user_info: UserInfo?
    let user_favorites: [Favorites]?
}

struct UserInfo: Codable {
    let user_name,
        user_surname,
        user_mail,
        user_password: String?
}

struct Favorites: Codable {
    let food_name,
        food_image: String?
}

struct FavoritesModel {
    let foodName, foodImage: String
    let foodImageUrl: URL

    init(favorite: Favorites) {
        self.foodName = favorite.food_name ?? ""
        self.foodImage = favorite.food_image ?? ""
        self.foodImageUrl = URL.makeImageUrl(from: self.foodImage)!
    }
}
