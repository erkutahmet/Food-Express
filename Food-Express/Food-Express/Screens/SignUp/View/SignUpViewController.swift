//
//  SignUpViewController.swift
//  Food-Express
//
//  Created by erkut on 6.10.2024.
//

import UIKit

final class SignUpViewController: UIViewController {

    @IBOutlet private weak var signupBackgroundView: UIView!
    @IBOutlet weak var signUpBtn: UIButton!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var lastnameTextField: UILabel!
    @IBOutlet weak var emailTextField: UILabel!
    @IBOutlet weak var passwordTextField: UILabel!
    @IBOutlet weak var confirmPassTextField: UILabel!
    
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
    @IBAction func signUpBtnClicked(_ sender: Any) {
    }
    @IBAction func signInBtnClicked(_ sender: Any) {
        self.dismiss(animated: true)
    }
}
