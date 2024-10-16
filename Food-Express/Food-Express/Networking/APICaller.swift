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
            case .failure:
                completionHandler(.failure(.decodingError))
            }
        }
    }
}
