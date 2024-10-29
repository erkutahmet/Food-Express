//
//  SettingsChangesPopUpViewController.swift
//  Food-Express
//
//  Created by erkut on 24.10.2024.
//

import UIKit

enum ChangesPopUpType {
    case email
    case password
}

protocol SettingsChangesPopUpViewInterface: AnyObject {
    func appear(sender: UIViewController, popUpType: ChangesPopUpType)
    func configView()
    func updateUIForPopUpType()
    func showAlertFromVM(status: Bool, title: String, message: String)
    func showDoneAlert(title: String, message: String)
    func validateEmailFields(currentUserMail: String) -> (isValid: Bool, errorMessage: String?)
    func validatePasswordFields(currentUserPassword: String) -> (isValid: Bool, errorMessage: String?)
    func getUpdateValue() -> String?
}

final class SettingsChangesPopUpViewController: UIViewController {

    @IBOutlet private weak var oldinfoLabel: UILabel!
    @IBOutlet private weak var newinfoLabel: UILabel!
    @IBOutlet private weak var confirmNewinfoLabel: UILabel!
    @IBOutlet private weak var oldinfoTextField: UITextField!
    @IBOutlet private weak var newinfoTextField: UITextField!
    @IBOutlet private weak var confirmNewinfoTextField: UITextField!
    @IBOutlet private weak var saveChangesBtn: UIButton!
    @IBOutlet private weak var confirmNewView: UIView!
    @IBOutlet private weak var contentView: UIView!
    @IBOutlet private weak var backView: UIView!

    private lazy var viewModel = SettingsChangesPopUpViewModel()
    private var popUpType: ChangesPopUpType?

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.view = self
        viewModel.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        viewModel.viewWillAppear()
    }

    init() {
        super.init(nibName: "SettingsChangesPopUpViewController", bundle: nil)
        self.modalPresentationStyle = .overFullScreen
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func show() {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut) {
            self.backView.alpha = 1
            self.contentView.alpha = 1
        }
    }

    private func hide() {
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut) {
            self.backView.alpha = 0
            self.contentView.alpha = 0
        } completion: { _ in
            self.dismiss(animated: false)
            self.removeFromParent()
        }
    }
    
    @IBAction private func saveChangesBtnClicked(_ sender: UIButton) {
        guard let popUpType = popUpType else { return }
        
        setButtonAvailable(is: false)
        
        switch popUpType {
        case .email:
            viewModel.fetchUserInfo(from: .email)
        case .password:
            viewModel.fetchUserInfo(from: .password)
        }
    }

    @IBAction func closeBtnClicked(_ sender: Any) {
        self.hide()
    }
}

extension SettingsChangesPopUpViewController: SettingsChangesPopUpViewInterface {
    func appear(sender: UIViewController, popUpType: ChangesPopUpType) {
        self.popUpType = popUpType
        sender.present(self, animated: false) {
            DispatchQueue.main.async {
                self.show()
            }
        }
    }
    
    func showDoneAlert(title: String, message: String) {
        self.errorShowAlert(title: title, message: message) {
            self.setButtonAvailable(is: true)
            self.hide()
        }
    }

    func showAlertFromVM(status: Bool, title: String, message: String) {
        if status {
            self.successShowAlert(title: title, message: message) {
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                let loginVC = LoginViewController()
                appDelegate.window?.rootViewController = loginVC
                appDelegate.window?.makeKeyAndVisible()
                self.setButtonAvailable(is: true)
            }
        } else {
            self.errorShowAlert(title: title, message: message) {
                self.setButtonAvailable(is: true)
            }
        }
    }

    private func setButtonAvailable(is bool: Bool) {
        if bool {
            saveChangesBtn.isEnabled = true
            saveChangesBtn.backgroundColor = UIColor.black
        } else {
            saveChangesBtn.isEnabled = false
            saveChangesBtn.backgroundColor = UIColor(hex: "#B3B3B3")
        }
    }

    func getUpdateValue() -> String? {
        return newinfoTextField.text
    }

    func validateEmailFields(currentUserMail: String) -> (isValid: Bool, errorMessage: String?) {
        
        guard let oldEmail = oldinfoTextField.text, !oldEmail.isEmpty, EmailValidator.isValidEmail(oldEmail) else {
            return (false, "Please enter your old email.")
        }
        
        guard EmailValidator.isValidEmail(oldEmail) else {
            return (false, "Please enter a vaild email.\n(Old mail)")
        }
        
        guard oldEmail == currentUserMail else {
            return (false, "Current email does not match.")
        }
        
        guard let newEmail = newinfoTextField.text, !newEmail.isEmpty else {
            return (false, "Please enter your new email.")
        }
        
        guard EmailValidator.isValidEmail(newEmail) else {
            return (false, "Please enter a vaild email.\n(New mail)")
        }
        
        return (true, nil)
    }
    
    func validatePasswordFields(currentUserPassword: String) -> (isValid: Bool, errorMessage: String?) {
        
        guard let oldPassword = oldinfoTextField.text, !oldPassword.isEmpty else {
            return (false, "Please enter your curent password.")
        }
        
        guard oldPassword == currentUserPassword else {
            return (false, "Current password does not match.")
        }
        
        guard let newPassword = newinfoTextField.text, !newPassword.isEmpty else {
            return (false, "Please enter your new password.")
        }
        
        guard newPassword.count >= 6 else {
            return (false, "Password must be at least 6 characters long.")
        }
        
        guard let confirmNewPassword = confirmNewinfoTextField.text, !confirmNewPassword.isEmpty else {
            return (false, "Please enter your new password again.")
        }
        
        guard confirmNewPassword == newPassword else {
            return (false, "New passwords do not match.")
        }
        
        return (true, nil)
    }

    func configView() {
        self.view.backgroundColor = .clear
        self.backView.backgroundColor = .black.withAlphaComponent(0.4)
        self.backView.alpha = 0
        self.contentView.layer.cornerRadius = 20
        self.saveChangesBtn.layer.cornerRadius = 12
        self.saveChangesBtn.layer.maskedCorners = [ .layerMinXMinYCorner, .layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        setupDismissKeyboardOnTap()
        
        let eyeButton = createEyeButton(action: #selector(togglePasswordVisibility))
        oldinfoTextField.rightView = eyeButton
        oldinfoTextField.rightViewMode = .always
        let eyeButton2 = createEyeButton(action: #selector(togglePasswordVisibility))
        newinfoTextField.rightView = eyeButton2
        newinfoTextField.rightViewMode = .always
        let eyeButton3 = createEyeButton(action: #selector(togglePasswordVisibility))
        confirmNewinfoTextField.rightView = eyeButton3
        confirmNewinfoTextField.rightViewMode = .always
    }

    func updateUIForPopUpType() {
       guard let popUpType = popUpType else { return }

       switch popUpType {
       case .email:
           oldinfoLabel.text = "Old Email"
           newinfoLabel.text = "New Email"
           confirmNewinfoLabel.text = ""
           oldinfoTextField.text = ""
           newinfoTextField.text = ""
           confirmNewinfoTextField.text = ""
           oldinfoTextField.setPlaceholder("oldmail@example.com")
           newinfoTextField.setPlaceholder("newmail@example.com")
           confirmNewinfoTextField.setPlaceholder("")
           oldinfoTextField.isSecureTextEntry = false
           newinfoTextField.isSecureTextEntry = false
           confirmNewinfoTextField.isSecureTextEntry = false
           confirmNewView.isHidden = true
           oldinfoTextField.rightView?.isHidden = true
           newinfoTextField.rightView?.isHidden = true
           confirmNewinfoTextField.rightView?.isHidden = true
       case .password:
           oldinfoLabel.text = "Old Password"
           newinfoLabel.text = "New Password"
           confirmNewinfoLabel.text = "Confirm New Password"
           oldinfoTextField.text = ""
           newinfoTextField.text = ""
           confirmNewinfoTextField.text = ""
           oldinfoTextField.setPlaceholder("••••••••")
           newinfoTextField.setPlaceholder("••••••••")
           confirmNewinfoTextField.setPlaceholder("••••••••")
           oldinfoTextField.isSecureTextEntry = true
           newinfoTextField.isSecureTextEntry = true
           confirmNewinfoTextField.isSecureTextEntry = true
           confirmNewView.isHidden = false
           oldinfoTextField.rightView?.isHidden = false
           newinfoTextField.rightView?.isHidden = false
           confirmNewinfoTextField.rightView?.isHidden = false
       }
   }
}
