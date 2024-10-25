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

protocol SettingsChangesPopUpInterface {
    func appear(sender: UIViewController, popUpType: ChangesPopUpType)
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
    private let eyeButton: UIButton = {
        let button = UIButton(type: .custom)
        button.tintColor = .systemGray
        button.setImage(UIImage(systemName: "eye"), for: .normal)
        button.setImage(UIImage(systemName: "eye.slash"), for: .selected)
        return button
    }()


    private var popUpType: ChangesPopUpType?

    private var isPasswordVisible = false

    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
    }

    override func viewWillAppear(_ animated: Bool) {
        updateUIForPopUpType()
    }

    init() {
        super.init(nibName: "SettingsChangesPopUpViewController", bundle: nil)
        self.modalPresentationStyle = .overFullScreen
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configView() {
        self.view.backgroundColor = .clear
        self.backView.backgroundColor = .black.withAlphaComponent(0.4)
        self.backView.alpha = 0
        self.contentView.layer.cornerRadius = 20
        self.saveChangesBtn.layer.cornerRadius = 12
        self.saveChangesBtn.layer.maskedCorners = [ .layerMinXMinYCorner, .layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        eyeButton.addTarget(self, action: #selector(togglePasswordVisibility), for: .touchUpInside)
    }

    private func updateUIForPopUpType() {
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
            oldinfoTextField.rightView = nil
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
            oldinfoTextField.rightView = eyeButton
            oldinfoTextField.rightViewMode = .always
        }
    }

    @objc private func togglePasswordVisibility(sender: UIButton) {
        isPasswordVisible.toggle()
        oldinfoTextField.isSecureTextEntry = !isPasswordVisible
        newinfoTextField.isSecureTextEntry = !isPasswordVisible
        confirmNewinfoTextField.isSecureTextEntry = !isPasswordVisible
        sender.isSelected = isPasswordVisible
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
        // TODO: This will be change, when backend connected
        sender.disableTemporarilyWithTapEffect(duration: 1)
        switch popUpType {
        case .email:
            print("Email changed!")
        case .password:
            print("Password changed!")
        }
    }

    @IBAction func closeBtnClicked(_ sender: Any) {
        self.hide()
    }
}

extension SettingsChangesPopUpViewController: SettingsChangesPopUpInterface {
    func appear(sender: UIViewController, popUpType: ChangesPopUpType) {
        self.popUpType = popUpType
        sender.present(self, animated: false) {
            DispatchQueue.main.async {
                self.show()
            }
        }
    }
}
