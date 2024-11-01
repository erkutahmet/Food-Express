//
//  LoginViewModel.swift
//  Food-Express
//
//  Created by erkut on 20.10.2024.
//

import Foundation

protocol LoginViewModelInterface {
    var view: LoginViewInterface? { get set }

    func viewDidLoad()
    func loginUser(email: String, password: String)
}

final class LoginViewModel {
    weak var view: LoginViewInterface?
}

extension LoginViewModel: LoginViewModelInterface {

    func viewDidLoad() {
        view?.setUI()
        view?.setupPasswordField()
    }

    func loginUser(email: String, password: String) {
        APICaller.loginUser(email: email, password: password) { [weak self] success, message in

            guard let self = self else { return }

            if success {
                self.view?.showAlertFromVM(status: true,
                                           title: "Welcome!",
                                           message: message ?? "Logging in...")
            } else {
                self.view?.showAlertFromVM(status: false,
                                           title: "Error",
                                           message: message ?? "Uknown error.")
            }
        }
    }
}
