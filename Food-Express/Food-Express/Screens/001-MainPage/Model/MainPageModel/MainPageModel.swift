//
//  MainPageModel.swift
//  Food-Express
//
//  Created by erkut on 9.10.2024.
//

import Foundation

struct MainPageModel: Codable {
    let yemekler: [Foods]?
    let success: Int?
}

struct Foods: Codable {
    let yemek_id, yemek_adi, yemek_resim_adi, yemek_fiyat: String?
}

struct FoodViewModel {
    let yemekID, yemekAdi, yemekResimAdi, yemekFiyat: String
    let imageURL: URL
    
    init(food: Foods) {
        self.yemekID = food.yemek_id ?? ""
        self.yemekAdi = food.yemek_adi ?? ""
        self.yemekResimAdi = food.yemek_resim_adi ?? ""
        self.yemekFiyat = food.yemek_fiyat ?? ""
        self.imageURL = URL.makeImageUrl(from: self.yemekResimAdi)!
    }
}
