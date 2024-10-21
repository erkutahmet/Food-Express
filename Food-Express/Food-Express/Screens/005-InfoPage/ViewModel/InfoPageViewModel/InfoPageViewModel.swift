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
    }

    func signOutUser() {
        APICaller.signOutUser { [weak self] success, message in
            guard let self = self else { return }
            
            if success {
                self.view?.showAlertFromVM(status: true, title: "Logging out...", message: message ?? "Your account is being logged out securely.")
            } else {
                self.view?.showAlertFromVM(status: false, title: "Error Signing Out", message: message ?? "Uknown error.")
            }
        }
    }
}
