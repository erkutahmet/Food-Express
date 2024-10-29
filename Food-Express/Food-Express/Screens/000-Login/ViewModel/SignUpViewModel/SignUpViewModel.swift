//
//  SignUpViewModel.swift
//  Food-Express
//
//  Created by erkut on 20.10.2024.
//

import Foundation

protocol SignUpViewModelInterface {
    var view: SignUpViewInterface? { get set }
    
    func viewDidLoad()
    func registerUser(data: UserModel, email: String, password: String)
}

final class SignUpViewModel {
    weak var view: SignUpViewInterface?
}

extension SignUpViewModel: SignUpViewModelInterface {
    func viewDidLoad() {
        view?.setUI()
        view?.setupPasswordField()
    }

    func registerUser(data: UserModel, email: String, password: String) {
        APICaller.registerUser(data: data) { [weak self] errorMessage in
            
            guard let self = self else { return }
            
            if let message = errorMessage {
                self.view?.showAlertFromVM(status: false, title: "Registration Error", message: message)
            } else {
                APICaller.loginUser(email: email, password: password) { success, message in
                    if success {
                        self.view?.showAlertFromVM(status: true, title: "Registration Successful", message: "Your account has been successfully created. You can now start using the app.")
                    } else {
                        self.view?.showAlertFromVM(status: false, title: "Unkown Error", message: "An unknown error occurred. Please try again.")
                    }
                }
            }
        }
    }
}
