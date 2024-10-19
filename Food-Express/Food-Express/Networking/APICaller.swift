//
//  APICaller.swift
//  Food-Express
//
//  Created by erkut on 9.10.2024.
//

import Foundation
import Alamofire
import AlamofireImage

enum NetworkError: Error {
    case urlError
    case responseError(String)
    case decodingError
    case encodingError
    case serverError(Int)
    case timeourError
    case uknownError
}

public class APICaller {
    
    static func getAllFoods(completionHandler: @escaping (_ result: Result<MainPageModel, NetworkError>) -> Void) {
        
        let urlString = NetworkConstant.shared.getAllFoods
        
        guard let url = URL(string: urlString) else {
            completionHandler(.failure(.urlError))
            return
        }
        
        AF.request(url).responseDecodable(of: MainPageModel.self) { response in
            
            switch response.result {
            case .success(let mainPageModel):
                completionHandler(.success(mainPageModel))
            case .failure(let error):
                completionHandler(.failure(.decodingError))
                print(error.localizedDescription)
            }
        }
    }

    static func addFoodToBasket(ad: String, resim: String, fiyat: String, adet: String, completionHandler: @escaping (_ result: Result<CRUDResponse, NetworkError>) -> Void) {
    
        let urlString = NetworkConstant.shared.addFoodToBasket
        
        let params = [
            "yemek_adi": ad,
            "yemek_resim_adi": resim,
            "yemek_fiyat": fiyat,
            "yemek_siparis_adet": adet,
            "kullanici_adi": "123jsonparse123deneme"
        ]
        
        guard let url = URL(string: urlString) else {
            completionHandler(.failure(.urlError))
            return
        }
        
        AF.request(url, method: .post, parameters: params, encoding: URLEncoding.default).responseDecodable(of: CRUDResponse.self) { response in
            switch response.result {
            case .success(let result):
                completionHandler(.success(result))
            case .failure(let error):
                completionHandler(.failure(.decodingError))
                print("-->\(error.localizedDescription)")
            }
        }
    }

    static func getFoodInBasket(completionHandler: @escaping (_ result: Result<BasketModel, NetworkError>) -> Void) {

        let urlString = NetworkConstant.shared.getBasketFoods

        let params = ["kullanici_adi": "123jsonparse123deneme"]

        guard let url = URL(string: urlString) else {
            completionHandler(.failure(.urlError))
            return
        }

        AF.request(url, method: .post, parameters: params, encoding: URLEncoding.default).responseDecodable(of: BasketModel.self) { response in

            switch response.result {
            case .success(let basketModel):
                completionHandler(.success(basketModel))
            case .failure(let error):
                completionHandler(.failure(.decodingError))
                print("-->\(error.localizedDescription)")
            }
        }
    }

    static func deleteFoodFromBasket(id: String, completionHandler: @escaping (_ result: Result<CRUDResponse, NetworkError>) -> Void) {

        let urlString = NetworkConstant.shared.removeFoodFromBasket

        let params = [
            "sepet_yemek_id": id,
            "kullanici_adi": "123jsonparse123deneme"
        ]

        guard let url = URL(string: urlString) else {
            completionHandler(.failure(.urlError))
            return
        }

        AF.request(url, method: .post, parameters: params, encoding: URLEncoding.default).responseDecodable(of: CRUDResponse.self) { response in
            switch response.result {
            case .success(let result):
                completionHandler(.success(result))
            case .failure(let error):
                completionHandler(.failure(.decodingError))
                print("-->\(error.localizedDescription)")
            }
        }
    }
}
