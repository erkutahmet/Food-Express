//
//  MainPageModel.swift
//  Food-Express
//
//  Created by erkut on 9.10.2024.
//

import Foundation

struct MainPageModel: Codable {
    let yemekler: [Yemekler]?
    let success: Int?
}

struct Yemekler: Codable {
    let yemekID, yemekAdi, yemekResimAdi, yemekFiyat: String?

    enum CodingKeys: String, CodingKey {
        case yemekID = "yemek_id"
        case yemekAdi = "yemek_adi"
        case yemekResimAdi = "yemek_resim_adi"
        case yemekFiyat = "yemek_fiyat"
    }
}
