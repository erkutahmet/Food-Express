//
//  LoginViewController.swift
//  Food-Express
//
//  Created by erkut on 6.10.2024.
//

import UIKit

final class LoginViewController: UIViewController {

    @IBOutlet private weak var loginBackgroundView: UIView!
    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var loginBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }

    private func setUI() {
        loginBackgroundView.layer.cornerRadius = 72
        loginBackgroundView.layer.maskedCorners = [ .layerMinXMinYCorner ]
        loginBtn.layer.cornerRadius = 12
        loginBtn.layer.maskedCorners = [ .layerMinXMinYCorner, .layerMaxXMaxYCorner, .layerMinXMaxYCorner]
    }
    @IBAction func loginBtnClicked(_ sender: Any) {
    }
    @IBAction func signupBtnClicked(_ sender: Any) {
    }
}
