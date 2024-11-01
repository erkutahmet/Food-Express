//
//  LoginViewController.swift
//  Food-Express
//
//  Created by erkut on 6.10.2024.
//

import UIKit

protocol LoginViewInterface: AnyObject {
    func setUI()
    func setupPasswordField()
    func validateFields() -> (isValid: Bool, errorMessage: String?)
    func showAlertFromVM(status: Bool, title: String, message: String)
}

final class LoginViewController: UIViewController {

    @IBOutlet private weak var loginBackgroundView: UIView!
    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var loginBtn: UIButton!

    private lazy var viewModel = LoginViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.view = self
        viewModel.viewDidLoad()
    }

    @IBAction private func loginBtnClicked(_ sender: UIButton) {
        sender.isEnabled = false
        sender.backgroundColor = UIColor(hex: "#B3B3B3")
        if !validateFields().isValid {
            errorShowAlert(title: "Error", message: validateFields().errorMessage ?? "An unexpected error occurred.") {
                sender.isEnabled = true
                sender.backgroundColor = UIColor.black
            }
        } else {
            viewModel.loginUser(email: emailTextField.text!, password: passwordTextField.text!)
        }
    }
    @IBAction private func signupBtnClicked(_ sender: Any) {
        let nextVC = SignUpViewController(nibName: "SignUpViewController", bundle: nil)
        nextVC.modalPresentationStyle = .popover
        self.present(nextVC, animated: true)
    }
}

extension LoginViewController: LoginViewInterface {
    func setUI() {
        loginBackgroundView.layer.cornerRadius = 72
        loginBackgroundView.layer.maskedCorners = [ .layerMinXMinYCorner ]
        loginBtn.layer.cornerRadius = 12
        loginBtn.layer.maskedCorners = [ .layerMinXMinYCorner, .layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        emailTextField.setPlaceholder("example@gmail.com")
        passwordTextField.setPlaceholder("••••••••")
        setupDismissKeyboardOnTap()
    }

    func setupPasswordField() {
        let eyeButton = createEyeButton(action: #selector(togglePasswordVisibility))
        passwordTextField.rightView = eyeButton
        passwordTextField.rightViewMode = .always
    }

    func validateFields() -> (isValid: Bool, errorMessage: String?) {

        guard let email = emailTextField.text, !email.isEmpty, EmailValidator.isValidEmail(email) else {
            return (false, "Please enter a valid email.")
        }

        guard let password = passwordTextField.text, !password.isEmpty else {
            return (false, "Please enter your password.")
        }

        guard password.count >= 6 else {
            return (false, "Password must be at least 6 characters long.")
        }

        return (true, nil)
    }

    func showAlertFromVM(status: Bool, title: String, message: String) {
        if status {
            self.successShowAlert(title: title, message: message) {
                self.loginBtn.isEnabled = true
                self.loginBtn.backgroundColor = UIColor.black
                let mainVC = TabBarViewController()
                self.setRootViewController(mainVC, animated: true)
            }
        } else {
            self.errorShowAlert(title: title, message: message) {
                self.loginBtn.isEnabled = true
                self.loginBtn.backgroundColor = UIColor.black
            }
        }
    }
}
