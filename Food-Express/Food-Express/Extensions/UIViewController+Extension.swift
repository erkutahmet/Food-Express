//
//  UIViewController+Extension.swift
//  Food-Express
//
//  Created by erkut on 21.10.2024.
//

import UIKit

extension UIViewController {
    func errorShowAlert(title: String,
                        message: String,
                        buttonTitle: String = "Okay",
                        completion: (() -> Void)? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: buttonTitle, style: .default, handler: { _ in
            completion?()
        }))
        self.present(alertController, animated: true)
    }

    func successShowAlert(title: String,
                          message: String,
                          duration: TimeInterval = 3.0,
                          completion: (() -> Void)? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        self.present(alertController, animated: true)

        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            alertController.dismiss(animated: true) {
                completion?()
            }
        }
    }

    func errorShowAlertWithOptions(title: String,
                                   message: String,
                                   okButtonTitle: String = "Okay",
                                   cancelButtonTitle: String = "Cancel",
                                   okCompletion: (() -> Void)? = nil,
                                   cancelCompletion: (() -> Void)? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)

        alertController.addAction(UIAlertAction(title: okButtonTitle, style: .destructive, handler: { _ in
            okCompletion?()
        }))

        alertController.addAction(UIAlertAction(title: cancelButtonTitle, style: .cancel, handler: { _ in
            cancelCompletion?()
        }))

        self.present(alertController, animated: true)
    }

    func createEyeButton(action: Selector) -> UIButton {
        let eyeButton = UIButton(type: .custom)
        eyeButton.tintColor = .systemGray
        eyeButton.setImage(UIImage(systemName: "eye"), for: .normal)
        eyeButton.setImage(UIImage(systemName: "eye.slash"), for: .selected)
        eyeButton.addTarget(self, action: action, for: .touchUpInside)
        return eyeButton
    }

    @objc func togglePasswordVisibility(sender: UIButton) {
        guard let textField = sender.superview as? UITextField else { return }

        textField.isSecureTextEntry.toggle()
        sender.isSelected = !textField.isSecureTextEntry
    }

    func setupDismissKeyboardOnTap() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }

    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }

    func setRootViewController(_ viewController: UIViewController,
                               animated: Bool) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }

        if animated {
            UIView.transition(with: appDelegate.window!, duration: 0.5, options: .transitionCrossDissolve, animations: {
                appDelegate.window?.rootViewController = viewController
                appDelegate.window?.makeKeyAndVisible()
            }, completion: nil)
        } else {
            appDelegate.window?.rootViewController = viewController
            appDelegate.window?.makeKeyAndVisible()
        }
    }
}
