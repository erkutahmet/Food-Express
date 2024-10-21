//
//  AppDelegate.swift
//  Food-Express
//
//  Created by erkut on 6.10.2024.
//

import UIKit
import FirebaseCore
import FirebaseAuth

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        
        window = UIWindow(frame: UIScreen.main.bounds)
        
        let savedStyle = UserDefaults.standard.string(forKey: "userInterfaceStyle") ?? "light"
        window?.overrideUserInterfaceStyle = (savedStyle == "dark") ? .dark : .light
        
        if UserDefaults.standard.bool(forKey: "isUserLoggedIn") {
            let mainVC = TabBarViewController()
            window?.rootViewController = mainVC
        } else {
            let loginVC = LoginViewController()
            window?.rootViewController = loginVC
        }

        window?.makeKeyAndVisible()
        return true
    }
}
