//
//  SettingsChangesPopUpViewModel.swift
//  Food-Express
//
//  Created by erkut on 26.10.2024.
//

import Foundation

protocol SettingsChangesPopUpViewModelInterface {
    var view: SettingsChangesPopUpViewInterface? { get set }

    func viewDidLoad()
    func viewWillAppear()
    func fetchUserInfo(from changesPopUp: ChangesPopUpType)
}

final class SettingsChangesPopUpViewModel {
    weak var view: SettingsChangesPopUpViewInterface?
}

extension SettingsChangesPopUpViewModel: SettingsChangesPopUpViewModelInterface {
    func viewDidLoad() {
        view?.configView()
    }

    func viewWillAppear() {
        view?.updateUIForPopUpType()
    }

    func fetchUserInfo(from changesPopUp: ChangesPopUpType) {
        APICaller.fetchUserData { [weak self] userModel, error in
            guard let self = self else { return }

            if let error = error {
                self.handleError(error)
                return
            }

            guard let userModel = userModel else {
                self.view?.showAlertFromVM(status: false, title: "Error", message: "Unable to retrieve user information.")
                return
            }

            switch changesPopUp {
            case .email:
                self.updateEmail(for: userModel)
            case .password:
                self.updatePassword(for: userModel)
            }
        }
    }

    private func handleError(_ error: Error) {
        if (error as NSError).domain == "AuthError" {
            view?.showAlertFromVM(status: true, title: "Session Expired", message: "Please sign in again to continue.")
        } else {
            view?.showAlertFromVM(status: false, title: "Error", message: error.localizedDescription)
        }
    }

    private func updateEmail(for userModel: UserModel) {
        guard let currentMail = userModel.user_info?.user_mail else { return }

        let validationResult = view?.validateEmailFields(currentUserMail: currentMail)

        if let errorMessage = validationResult?.errorMessage, validationResult?.isValid == false {
            view?.showAlertFromVM(status: false, title: "Error", message: errorMessage)
            return
        }

        let newMail = view?.getUpdateValue() ?? ""
        APICaller.updateUserCredentials(newMail: newMail, newPassword: userModel.user_info?.user_password) { error in
            if let error = error {
                self.view?.showAlertFromVM(status: false, title: "Error", message: error.localizedDescription)
            } else {
                self.view?.showDoneAlert(title: "Success", message: "Your email has been successfully updated.")
                print("Email updated!")
            }
        }
    }

    private func updatePassword(for userModel: UserModel) {
        guard let currentPassword = userModel.user_info?.user_password else { return }

        let validationResult = view?.validatePasswordFields(currentUserPassword: currentPassword)

        if let errorMessage = validationResult?.errorMessage, validationResult?.isValid == false {
            view?.showAlertFromVM(status: false, title: "Error", message: errorMessage)
            return
        }

        let newPassword = view?.getUpdateValue() ?? ""
        APICaller.updateUserCredentials(newMail: userModel.user_info?.user_mail, newPassword: newPassword) { error in
            if let error = error {
                self.view?.showAlertFromVM(status: false, title: "Error", message: error.localizedDescription)
            } else {
                self.view?.showDoneAlert(title: "Success", message: "Your password has been successfully updated.")
                print("Password updated!")
            }
        }
    }
}
