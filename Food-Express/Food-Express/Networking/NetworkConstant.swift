//
//  NetworkConstant.swift
//  Food-Express
//
//  Created by erkut on 9.10.2024.
//

import Foundation

final class NetworkConstant {
    
    public static var shared: NetworkConstant = NetworkConstant()

    private init() {}

    public var yemeklerGetir: String {
        get {
            return "http://kasimadalan.pe.hu/yemekler/tumYemekleriGetir.php"
        }
    }

    public var sepetYemekEkle: String {
        get {
            return "http://kasimadalan.pe.hu/yemekler/sepeteYemekEkle.php"
        }
    }

    public var sepetYemekGetir: String {
        get {
            return "http://kasimadalan.pe.hu/yemekler/sepettekiYemekleriGetir.php"
        }
    }

    public var sepetYemekSil: String {
        get {
            return "http://kasimadalan.pe.hu/yemekler/sepettenYemekSil.php"
        }
    }

    public var yemekResimAlBaseUrl: String {
        get {
            return "http://kasimadalan.pe.hu/yemekler/resimler/"
        }
    }
}
