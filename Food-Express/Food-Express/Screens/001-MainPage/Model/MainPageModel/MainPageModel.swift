//
//  MainPageModel.swift
//  Food-Express
//
//  Created by erkut on 9.10.2024.
//

import Foundation

struct MainPageModel: Codable {
    let yemekler: [Foods]
    let success: Int
}

struct Foods: Codable {
    let yemekID, yemekAdi, yemekResimAdi, yemekFiyat: String?

    enum CodingKeys: String, CodingKey {
        case yemekID = "yemek_id"
        case yemekAdi = "yemek_adi"
        case yemekResimAdi = "yemek_resim_adi"
        case yemekFiyat = "yemek_fiyat"
    }
}

struct FoodViewModel {
    let yemekID, yemekAdi, yemekResimAdi, yemekFiyat: String
    let imageURL: URL?
    
    init(food: Foods) {
        self.yemekID = food.yemekID ?? ""
        self.yemekAdi = food.yemekAdi ?? ""
        self.yemekResimAdi = food.yemekResimAdi ?? ""
        self.yemekFiyat = food.yemekFiyat ?? ""
        self.imageURL = URL.makeImageUrl(from: self.yemekResimAdi)
    }
}
