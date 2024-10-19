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

    static func addFoodToBasket(parameters: AddFoodBasketParameters, completionHandler: @escaping (_ result: Result<CRUDResponse, NetworkError>) -> Void) {
    
        let urlString = NetworkConstant.shared.addFoodToBasket
        
        guard let url = URL(string: urlString) else {
            completionHandler(.failure(.urlError))
            return
        }
        
        AF.request(url, method: .post, parameters: parameters.toDict(), encoding: URLEncoding.default).responseDecodable(of: CRUDResponse.self) { response in
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

        guard let url = URL(string: urlString) else {
            completionHandler(.failure(.urlError))
            return
        }

        AF.request(url, method: .post, parameters: GetFoodBasketParameters().toDict(), encoding: URLEncoding.default).responseDecodable(of: BasketModel.self) { response in

            switch response.result {
            case .success(let basketModel):
                completionHandler(.success(basketModel))
            case .failure(let error):
                completionHandler(.failure(.decodingError))
                print("-->\(error.localizedDescription)")
            }
        }
    }

    static func deleteFoodFromBasket(parameters: DeleteFoodBasketParameters, completionHandler: @escaping (_ result: Result<CRUDResponse, NetworkError>) -> Void) {

        let urlString = NetworkConstant.shared.removeFoodFromBasket

        guard let url = URL(string: urlString) else {
            completionHandler(.failure(.urlError))
            return
        }

        AF.request(url, method: .post, parameters: parameters.toDict(), encoding: URLEncoding.default).responseDecodable(of: CRUDResponse.self) { response in
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
