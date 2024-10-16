//
//  FoodCellViewModel.swift
//  Food-Express
//
//  Created by erkut on 10.10.2024.
//

import Foundation

struct FoodViewModel {
    let yemekID, yemekAdi, yemekResimAdi, yemekFiyat: String
    let imageURL: URL?
    
    init(food: Yemekler) {
        self.yemekID = food.yemekID ?? ""
        self.yemekAdi = food.yemekAdi ?? ""
        self.yemekResimAdi = food.yemekResimAdi ?? ""
        self.yemekFiyat = food.yemekFiyat ?? ""
        self.imageURL = URL.makeImageUrl(from: self.yemekResimAdi)
    }
}
