//
//  AppDelegate.swift
//  Food-Express
//
//  Created by erkut on 6.10.2024.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let window = UIWindow(frame: UIScreen.main.bounds)

        let savedStyle = UserDefaults.standard.string(forKey: "userInterfaceStyle") ?? "light"
        window.overrideUserInterfaceStyle = (savedStyle == "dark") ? .dark : .light

        window.rootViewController = TabBarViewController()
        window.makeKeyAndVisible()

        self.window = window
        return true
    }
}
