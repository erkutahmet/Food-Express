//
//  UIViewController+Extension.swift
//  Food-Express
//
//  Created by erkut on 21.10.2024.
//

import UIKit

extension UIViewController {
    func errorShowAlert(title: String, message: String, buttonTitle: String = "Okay", completion: (() -> Void)? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: buttonTitle, style: .default, handler: { _ in
            completion?()
        }))
        self.present(alertController, animated: true)
    }
    
    func successShowAlert(title: String, message: String, duration: TimeInterval = 3.0, completion: (() -> Void)? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        self.present(alertController, animated: true)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            alertController.dismiss(animated: true) {
                completion?()
            }
        }
    }

    func errorShowAlertWithOptions(title: String, message: String,
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
}
