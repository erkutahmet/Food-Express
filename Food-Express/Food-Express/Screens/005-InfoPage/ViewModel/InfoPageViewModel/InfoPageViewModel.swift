//
//  InfoPageViewModel.swift
//  Food-Express
//
//  Created by erkut on 21.10.2024.
//

import Foundation

protocol InfoPageViewModelInterface {
    var view: InfoPageViewInterface? { get set }

    func viewDidLoad()
    func signOutUser()
}

final class InfoPageViewModel {
    weak var view: InfoPageViewInterface?
}

extension InfoPageViewModel: InfoPageViewModelInterface {

    func viewDidLoad() {
        view?.setUI()
        fetchUserData()
    }

    func signOutUser() {
        APICaller.signOutUser { [weak self] success, message in
            guard let self = self else { return }

            if success {
                self.view?.showAlertFromVM(status: true,
                                           title: "Logging out...",
                                           message: message ?? "Your account is being logged out securely.")
            } else {
                self.view?.showAlertFromVM(status: false,
                                           title: "Error Signing Out",
                                           message: message ?? "Uknown error.")
            }
        }
    }

    func fetchUserData() {
        APICaller.fetchUserData { userModel, error in
            if let error = error {
                if (error as NSError).domain == "AuthError" {
                    self.view?.showAlertFromVM(status: true,
                                               title: "Session Expired",
                                               message: "Please sign in again to continue.")
                } else {
                    self.view?.showAlertFromVM(status: false,
                                               title: "Error",
                                               message: error.localizedDescription)
                }
            } else if let userModel = userModel {
                self.view?.bindUserInfo(name: userModel.user_info?.user_name ?? "Name",
                                        surname: userModel.user_info?.user_surname ?? "Surname")
            }
        }
    }
}
