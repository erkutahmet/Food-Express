//
//  TabBar.swift
//  Food-Express
//
//  Created by erkut on 7.10.2024.
//

import UIKit

class TabBar: UITabBar {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupTabBarItems()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupTabBarItems()
    }

    private func setupTabBarItems() {
        
    }
}
