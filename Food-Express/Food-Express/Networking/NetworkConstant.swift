//
//  NetworkConstant.swift
//  Food-Express
//
//  Created by erkut on 9.10.2024.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

final class NetworkConstant {

    public static var shared: NetworkConstant = NetworkConstant()

    private init() {}

    public var getAllFoods: String {
        return "http://kasimadalan.pe.hu/yemekler/tumYemekleriGetir.php"
    }

    public var addFoodToBasket: String {
        return "http://kasimadalan.pe.hu/yemekler/sepeteYemekEkle.php"
    }

    public var getBasketFoods: String {
        return "http://kasimadalan.pe.hu/yemekler/sepettekiYemekleriGetir.php"
    }

    public var removeFoodFromBasket: String {
        return "http://kasimadalan.pe.hu/yemekler/sepettenYemekSil.php"
    }

    public var foodImageBaseUrl: String {
        return "http://kasimadalan.pe.hu/yemekler/resimler/"
    }

    public var firestoreDB: Firestore {
        return Firestore.firestore()
    }

    public var currentUser: String? {
        return Auth.auth().currentUser?.uid
    }
}
