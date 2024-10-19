//
//  SignUpViewController.swift
//  Food-Express
//
//  Created by erkut on 6.10.2024.
//

import UIKit

final class SignUpViewController: UIViewController {

    @IBOutlet private weak var signupBackgroundView: UIView!
    @IBOutlet private weak var signUpBtn: UIButton!
    @IBOutlet private weak var nameTextField: UITextField!
    @IBOutlet private weak var lastnameTextField: UILabel!
    @IBOutlet private weak var emailTextField: UILabel!
    @IBOutlet private weak var passwordTextField: UILabel!
    @IBOutlet private weak var confirmPassTextField: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }

    private func setUI() {
        signupBackgroundView.layer.cornerRadius = 72
        signupBackgroundView.layer.maskedCorners = [ .layerMinXMinYCorner ]
        signUpBtn.layer.cornerRadius = 12
        signUpBtn.layer.maskedCorners = [ .layerMinXMinYCorner, .layerMaxXMaxYCorner, .layerMinXMaxYCorner]
    }
    @IBAction private func signUpBtnClicked(_ sender: Any) {
    }
    @IBAction private func signInBtnClicked(_ sender: Any) {
        self.dismiss(animated: true)
    }
}
