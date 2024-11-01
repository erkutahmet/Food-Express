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

    static func addFoodToBasket(parameters: AddFoodBasketParameters,
                                completionHandler: @escaping (_ result: Result<CRUDResponse, NetworkError>) -> Void) {

        let urlString = NetworkConstant.shared.addFoodToBasket
        guard let url = URL(string: urlString) else {
            completionHandler(.failure(.urlError))
            return
        }
        AF.request(url,
                   method: .post,
                   parameters: parameters.toDict(),
                   encoding: URLEncoding.default).responseDecodable(of: CRUDResponse.self) { response in
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
        AF.request(url,
                   method: .post,
                   parameters: GetFoodBasketParameters().toDict(),
                   encoding: URLEncoding.default).responseDecodable(of: BasketModel.self) { response in

            switch response.result {
            case .success(let basketModel):
                completionHandler(.success(basketModel))
            case .failure(let error):
                completionHandler(.failure(.decodingError))
                print("-->\(error.localizedDescription)")
            }
        }
    }

    static func deleteFoodFromBasket(parameters: DeleteFoodBasketParameters,
                                     completionHandler: @escaping (_ result: Result<CRUDResponse, NetworkError>)
                                     -> Void) {

        let urlString = NetworkConstant.shared.removeFoodFromBasket
        guard let url = URL(string: urlString) else {
            completionHandler(.failure(.urlError))
            return
        }
        AF.request(url,
                   method: .post,
                   parameters: parameters.toDict(),
                   encoding: URLEncoding.default).responseDecodable(of: CRUDResponse.self) { response in
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
        Auth.auth().createUser(withEmail: data.user_info?.user_mail ?? "",
                               password: data.user_info?.user_password ?? "") { authResult, error in
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

    static func saveUserToFirestore(data: UserModel,
                                    completionHandler: @escaping (String?) -> Void) {
        do {
            let firestoreDB = NetworkConstant.shared.firestoreDB
            try firestoreDB.collection("Users").document(data.user_uuid ?? "").setData(from: data) { error in
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

        Auth.auth().signIn(withEmail: email, password: password) { _, error in
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

    static func fetchUserData(completion: @escaping (UserModel?, Error?) -> Void) {
        guard let userID = NetworkConstant.shared.currentUser else {
            completion(nil, NSError(domain: "AuthError",
                                    code: 0,
                                    userInfo: [NSLocalizedDescriptionKey: "User not authenticated"]))
            return
        }
        let docRef = NetworkConstant.shared.firestoreDB.collection("Users").document(userID)

        docRef.getDocument { snapshot, error in
            guard let data = snapshot?.data(), error == nil else {
                completion(nil, error)
                return
            }
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: data)
                let userModel = try JSONDecoder().decode(UserModel.self, from: jsonData)

                completion(userModel, nil)
            } catch {
                completion(nil, error)
            }
        }
    }

    static func updateUserCredentials(newMail: String?, newPassword: String?, completion: @escaping (Error?) -> Void) {
        guard let userID = NetworkConstant.shared.currentUser else {
            completion(NSError(domain: "UserIDError",
                               code: 0,
                               userInfo: [NSLocalizedDescriptionKey: "User ID is missing"]))
            return
        }
        let currentUser = Auth.auth().currentUser
        let group = DispatchGroup()
        var updateError: Error?
        // MARK: This can be change
        if let mail = newMail {
            group.enter()
            currentUser?.updateEmail(to: mail) { error in
                if let error = error {
                    updateError = error
                }
                group.leave()
            }
        }
        if let password = newPassword {
            group.enter()
            currentUser?.updatePassword(to: password) { error in
                if let error = error {
                    updateError = error
                }
                group.leave()
            }
        }
        group.notify(queue: .main) {
            if let error = updateError {
                completion(error)
                return
            }
            var fieldsToUpdate: [String: Any] = [:]

            if let mail = newMail {
                fieldsToUpdate["user_info.user_mail"] = mail
            }
            if let password = newPassword {
                fieldsToUpdate["user_info.user_password"] = password
            }
            if !fieldsToUpdate.isEmpty {
                let docRef = NetworkConstant.shared.firestoreDB.collection("Users").document(userID)
                docRef.updateData(fieldsToUpdate) { error in
                    completion(error)
                }
            } else {
                completion(nil)
            }
        }
    }

    static func updateUserFavorites(newFavorite: Favorites, completion: @escaping (Error?) -> Void) {
        guard let userID = NetworkConstant.shared.currentUser else {
            completion(NSError(domain: "UserIDError",
                               code: 0,
                               userInfo: [NSLocalizedDescriptionKey: "User ID is missing"]))
            return
        }
        let docRef = NetworkConstant.shared.firestoreDB.collection("Users").document(userID)
        docRef.getDocument { document, error in
            if let error = error {
                completion(error)
                return
            }
            guard let document = document, document.exists, let userData = try? document.data(as: UserModel.self) else {
                completion(NSError(domain: "DataError",
                                   code: 0,
                                   userInfo: [NSLocalizedDescriptionKey: "User data not found"]))
                return
            }

            var updatedFavorites = userData.user_favorites ?? []
            if let index = updatedFavorites.firstIndex(where: { $0.food_name == newFavorite.food_name }) {
                updatedFavorites[index] = newFavorite
            } else {
                updatedFavorites.append(newFavorite)
            }
            let fieldsToUpdate: [String: Any] = [
                "user_favorites": updatedFavorites.map {
                    ["food_name": $0.food_name,
                     "food_image": $0.food_image]
                }]
            docRef.updateData(fieldsToUpdate) { error in
                if let error = error {
                    completion(error)
                } else {
                    completion(nil)
                    print("Favorites updated successfully!")
                }
            }
        }
    }

    static func fetchUserFavorites(completion: @escaping ([Favorites]?, Error?) -> Void) {
        guard let userID = NetworkConstant.shared.currentUser else {
            completion(nil, NSError(domain: "UserIDError",
                                    code: 0,
                                    userInfo: [NSLocalizedDescriptionKey: "User ID is missing"]))
            return
        }
        let docRef = NetworkConstant.shared.firestoreDB.collection("Users").document(userID)
        docRef.getDocument { document, error in
            if let error = error {
                completion(nil, error)
                return
            }
            guard let document = document, document.exists, let userData = try? document.data(as: UserModel.self) else {
                completion(nil, NSError(domain: "DataError",
                                        code: 0,
                                        userInfo: [NSLocalizedDescriptionKey: "User data not found"]))
                return
            }
            let favorites = userData.user_favorites
            completion(favorites, nil)
        }
    }

    static func deleteUserFavorite(foodName: String, completion: @escaping (Error?) -> Void) {
        guard let userID = NetworkConstant.shared.currentUser else {
            completion(NSError(domain: "UserIDError",
                               code: 0,
                               userInfo: [NSLocalizedDescriptionKey: "User ID is missing"]))
            return
        }
        let docRef = NetworkConstant.shared.firestoreDB.collection("Users").document(userID)
        docRef.getDocument { document, error in
            if let error = error {
                completion(error)
                return
            }
            guard let document = document, document.exists, let userData = try? document.data(as: UserModel.self) else {
                completion(NSError(domain: "DataError",
                                   code: 0,
                                   userInfo: [NSLocalizedDescriptionKey: "User data not found"]))
                return
            }
            guard var favorites = userData.user_favorites else {
                completion(NSError(domain: "FavoritesError",
                                   code: 0,
                                   userInfo: [NSLocalizedDescriptionKey: "No favorites found"]))
                return
            }
            if let index = favorites.firstIndex(where: { $0.food_name == foodName }) {
                favorites.remove(at: index)
            } else {
                completion(NSError(domain: "DeleteError",
                                   code: 0,
                                   userInfo: [NSLocalizedDescriptionKey: "Food not found in favorites"]))
                return
            }
            let fieldsToUpdate: [String: Any] = ["user_favorites": favorites.map { ["food_name": $0.food_name,
                                                                                    "food_image": $0.food_image] }]
            docRef.updateData(fieldsToUpdate) { error in
                if let error = error {
                    completion(error)
                } else {
                    completion(nil)
                    print("Favorite deleted successfully!")
                }
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
