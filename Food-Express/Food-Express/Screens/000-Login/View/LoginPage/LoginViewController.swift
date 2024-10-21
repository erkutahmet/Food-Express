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

    private var isPasswordVisible = false

    private lazy var viewModel = LoginViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.view = self
        viewModel.viewDidLoad()
    }

    @IBAction private func loginBtnClicked(_ sender: Any) {
        if !validateFields().isValid {
            errorShowAlert(title: "Error", message: validateFields().errorMessage ?? "An unexpected error occurred.")
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
    }
    
    func setupPasswordField() {
        let eyeButton = UIButton(type: .custom)
        eyeButton.tintColor = .systemGray
        eyeButton.setImage(UIImage(systemName: "eye"), for: .normal)
        eyeButton.setImage(UIImage(systemName: "eye.slash"), for: .selected)
        eyeButton.addTarget(self, action: #selector(togglePasswordVisibility), for: .touchUpInside)
        
        passwordTextField.rightView = eyeButton
        passwordTextField.rightViewMode = .always
    }
    
    @objc private func togglePasswordVisibility(sender: UIButton) {
        isPasswordVisible.toggle()
        passwordTextField.isSecureTextEntry = !isPasswordVisible
        sender.isSelected = isPasswordVisible
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
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                let mainVC = TabBarViewController()
                appDelegate.window?.rootViewController = mainVC
                appDelegate.window?.makeKeyAndVisible()
            }
        } else {
            self.errorShowAlert(title: title, message: message)
        }
    }
}
