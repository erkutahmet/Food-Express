//
//  APICaller.swift
//  Food-Express
//
//  Created by erkut on 9.10.2024.
//

import Foundation
import Alamofire
import AlamofireImage
import FirebaseFirestore
import FirebaseAuth

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

    static func registerUser(data: UserModel, completionHandler: @escaping (String?) -> Void) {
        Auth.auth().createUser(withEmail: data.user_info?.user_mail ?? "", password: data.user_info?.user_password ?? "") { authResult, error in
            if let error = error {
                completionHandler(error.localizedDescription)
                print("Error during user registration: \(error.localizedDescription)")
                return
            }
            
            guard let user = authResult?.user else {
                return
            }
            
            var userWithUUID = data
            userWithUUID.user_uuid = user.uid

            saveUserToFirestore(data: userWithUUID) { errorMessage in
                completionHandler(errorMessage)
            }
        }
    }
    
    static func saveUserToFirestore(data: UserModel, completionHandler: @escaping (String?) -> Void) {
        do {
            try NetworkConstant.shared.firestoreDB.collection("Users").document(data.user_uuid ?? "").setData(from: data) { error in
                if let error = error {
                    completionHandler("Error while setting user info: \(error.localizedDescription)")
                } else {
                    completionHandler(nil)
                }
            }
        } catch let error {
            completionHandler("Error while setting user info: \(error.localizedDescription)")
        }
    }

    static func loginUser(email: String, password: String, completionHandler: @escaping (Bool, String?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            
            if let error = error {
                completionHandler(false, error.localizedDescription)
                print("Error signing in: \(error.localizedDescription)")
                return
            } else {
                UserDefaults.standard.set(true, forKey: "isUserLoggedIn")
                completionHandler(true, "Logging in...")
                print("User signed in successfully")
            }
        }
    }

    static func signOutUser(completionHandler: @escaping (Bool, String?) -> Void) {
        do {
            try Auth.auth().signOut()
            UserDefaults.standard.set(false, forKey: "isUserLoggedIn")
            completionHandler(true, "Your account is being logged out securely.")
            print("User signed out successfully")
        } catch let signOutError as NSError {
            completionHandler(false, signOutError.localizedDescription)
            print("Error signing in: \(signOutError.localizedDescription)")
        }
    }
}
