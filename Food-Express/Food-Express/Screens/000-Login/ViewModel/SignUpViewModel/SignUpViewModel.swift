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
    func registerUser(data: UserModel)
}

final class SignUpViewModel {
    weak var view: SignUpViewInterface?
}

extension SignUpViewModel: SignUpViewModelInterface {
    func viewDidLoad() {
        view?.setUI()
        view?.setupPasswordField()
    }

    func registerUser(data: UserModel) {
        APICaller.registerUser(data: data) { [weak self] errorMessage in
            
            guard let self = self else { return }
            
            if let message = errorMessage {
                self.view?.showAlertFromVM(status: false, title: "Registration Error", message: message)
            } else {
                self.view?.showAlertFromVM(status: true, title: "Success", message: "User registered successfully.")
            }
        }
    }
}
