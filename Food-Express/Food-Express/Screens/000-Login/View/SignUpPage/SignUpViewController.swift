//
//  SignUpViewController.swift
//  Food-Express
//
//  Created by erkut on 6.10.2024.
//

import UIKit

protocol SignUpViewInterface: AnyObject {
    func setUI()
    func setupPasswordField()
    func validateFields() -> (isValid: Bool, errorMessage: String?)
    func showAlertFromVM(status: Bool, title: String, message: String)
    func registerUserData(name: String, surname: String, email: String, password: String) -> UserModel
}

final class SignUpViewController: UIViewController {

    @IBOutlet private weak var signupBackgroundView: UIView!
    @IBOutlet private weak var signUpBtn: UIButton!
    @IBOutlet private weak var nameTextField: UITextField!
    @IBOutlet private weak var lastnameTextField: UITextField!
    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var confirmPassTextField: UITextField!

    private var isPasswordVisible = false

    private lazy var viewModel = SignUpViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.view = self
        viewModel.viewDidLoad()
    }

    @IBAction private func signUpBtnClicked(_ sender: Any) {
        if !validateFields().isValid {
            errorShowAlert(title: "Error", message: validateFields().errorMessage ?? "An unexpected error occurred.")
        } else {
            viewModel.registerUser(data: registerUserData(name: nameTextField.text!,
                                                          surname: lastnameTextField.text!,
                                                          email: emailTextField.text!,
                                                          password: passwordTextField.text!))
        }
    }
    
    @IBAction private func signInBtnClicked(_ sender: Any) {
        self.dismiss(animated: true)
    }
}

extension SignUpViewController: SignUpViewInterface {
    
    func setUI() {
        signupBackgroundView.layer.cornerRadius = 72
        signupBackgroundView.layer.maskedCorners = [ .layerMinXMinYCorner ]
        signUpBtn.layer.cornerRadius = 12
        signUpBtn.layer.maskedCorners = [ .layerMinXMinYCorner, .layerMaxXMaxYCorner, .layerMinXMaxYCorner]
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
        confirmPassTextField.isSecureTextEntry = !isPasswordVisible
        sender.isSelected = isPasswordVisible
    }

    func validateFields() -> (isValid: Bool, errorMessage: String?) {

        guard let name = nameTextField.text, !name.isEmpty else {
            return (false, "Please enter your name.")
        }
        
        guard let surname = lastnameTextField.text, !surname.isEmpty else {
            return (false, "Please enter your surname.")
        }

        guard let email = emailTextField.text, !email.isEmpty, EmailValidator.isValidEmail(email) else {
            return (false, "Please enter a valid email.")
        }

        guard let password = passwordTextField.text, !password.isEmpty else {
            return (false, "Please enter your password.")
        }
        
        guard password.count >= 6 else {
            return (false, "Password must be at least 6 characters long.")
        }

        guard let confirmPassword = confirmPassTextField.text, !confirmPassword.isEmpty, password == confirmPassword else {
            return (false, "Passwords do not match.")
        }

        return (true, nil)
    }

    func registerUserData(name: String, surname: String, email: String, password: String) -> UserModel {
        let userInfo = UserModel.init(user_info: UserInfo.init(user_name: name, user_surname: surname, user_mail: email, user_password: password), user_favorites: nil)
        return userInfo
    }

    func showAlertFromVM(status: Bool, title: String, message: String) {
        if status {
            self.successShowAlert(title: title, message: message) {
                self.dismiss(animated: true)
            }
        } else {
            self.errorShowAlert(title: title, message: message)
        }
    }
}
