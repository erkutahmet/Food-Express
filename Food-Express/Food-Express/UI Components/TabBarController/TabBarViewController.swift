//
//  TabBarViewController.swift
//  Food-Express
//
//  Created by erkut on 7.10.2024.
//

import UIKit

final class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }

    private func configureUI() {
        let homeVC = MainPageViewController()
        let favoritesVC = FavoritesPageViewController()
        let basketVC = BasketPageViewController()
        let categoryVC = CategoriesPageViewController()
        let infoVC = InfoPageViewController()

        homeVC.tabBarItem = UITabBarItem(title: "Home",
                                    image: UIImage(systemName: "house"),
                                    selectedImage: UIImage(systemName: "house.fill"))

        favoritesVC.tabBarItem = UITabBarItem(title: "Favorites",
                                         image: UIImage(systemName: "heart"),
                                         selectedImage: UIImage(systemName: "heart.fill"))

        basketVC.tabBarItem = UITabBarItem(title: "Basket",
                                      image: UIImage(systemName: "basket"),
                                      selectedImage: UIImage(systemName: "basket.fill"))

        categoryVC.tabBarItem = UITabBarItem(title: "Categories",
                                    image: UIImage(systemName: "tray"),
                                    selectedImage: UIImage(systemName: "tray.fill"))

        infoVC.tabBarItem = UITabBarItem(title: "Settings",
                                    image: UIImage(systemName: "gearshape"),
                                    selectedImage: UIImage(systemName: "gearshape.fill"))

        let nav1 = UINavigationController(rootViewController: homeVC)
        let nav2 = UINavigationController(rootViewController: favoritesVC)
        let nav3 = UINavigationController(rootViewController: basketVC)
        let nav4 = UINavigationController(rootViewController: categoryVC)
        let nav5 = UINavigationController(rootViewController: infoVC)

        viewControllers = [nav1, nav2, nav3, nav4, nav5]

        tabBar.unselectedItemTintColor = .systemGray
        tabBar.tintColor = UIColor(hex: "#4A65C2")
    }
}
