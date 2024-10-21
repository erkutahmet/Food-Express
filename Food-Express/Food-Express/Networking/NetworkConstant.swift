//
//  NetworkConstant.swift
//  Food-Express
//
//  Created by erkut on 9.10.2024.
//

import Foundation
import FirebaseFirestore

final class NetworkConstant {
    
    public static var shared: NetworkConstant = NetworkConstant()

    private init() {}

    public var getAllFoods: String {
        get {
            return "http://kasimadalan.pe.hu/yemekler/tumYemekleriGetir.php"
        }
    }

    public var addFoodToBasket: String {
        get {
            return "http://kasimadalan.pe.hu/yemekler/sepeteYemekEkle.php"
        }
    }

    public var getBasketFoods: String {
        get {
            return "http://kasimadalan.pe.hu/yemekler/sepettekiYemekleriGetir.php"
        }
    }

    public var removeFoodFromBasket: String {
        get {
            return "http://kasimadalan.pe.hu/yemekler/sepettenYemekSil.php"
        }
    }

    public var foodImageBaseUrl: String {
        get {
            return "http://kasimadalan.pe.hu/yemekler/resimler/"
        }
    }

    public var firestoreDB: Firestore {
        get {
            return Firestore.firestore()
        }
    }
}
