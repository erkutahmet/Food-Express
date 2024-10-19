//
//  BasketModel.swift
//  Food-Express
//
//  Created by erkut on 11.10.2024.
//

import Foundation

struct BasketModel: Codable {
    let sepet_yemekler: [BasketFoods]?
    let success: Int?
}

struct BasketFoods: Codable {
    let sepet_yemek_id,
        yemek_adi,
        yemek_resim_adi,
        yemek_fiyat,
        yemek_siparis_adet,
        kullanici_adi: String?
}

struct ViewBasketModel {
    let sepetYemekID,
        yemekAdi,
        yemekResimAdi,
        yemekFiyat,
        yemekSiparisAdet,
        kullaniciAdi: String
    let imageURL: URL

    init (basket: BasketFoods) {
        self.sepetYemekID = basket.sepet_yemek_id ?? ""
        self.yemekAdi = basket.yemek_adi ?? ""
        self.yemekResimAdi = basket.yemek_resim_adi ?? ""
        self.yemekFiyat = basket.yemek_fiyat ?? ""
        self.yemekSiparisAdet = basket.yemek_siparis_adet ?? ""
        self.kullaniciAdi = basket.kullanici_adi ?? ""
        self.imageURL = URL.makeImageUrl(from: self.yemekResimAdi)!
    }
}
