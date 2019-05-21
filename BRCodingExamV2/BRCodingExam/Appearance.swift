//
//  AppDelegate.swift
//  BRCodingExam
//
//  Created by rickb on 5/16/19.
//  Copyright © 2019 rickb. All rights reserved.
//

import UIKit

func initAppearance() {
    UINavigationBar.appearance().barTintColor = .navbar
    UINavigationBar.appearance().tintColor = .white
    UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.white, .font: UIFont.semiBold(size: 17.0)]

    UITabBar.appearance().barTintColor = .tabbar
    UITabBar.appearance().tintColor = .white

    UITabBarItem.appearance().setTitleTextAttributes([.foregroundColor: UIColor.white, .font: UIFont.regular(size: 10)], for: .normal)
}

extension UIFont {

    static func semiBold(size: CGFloat) -> UIFont {
        return UIFont(name: "AvenirNext-DemiBold", size: size)!
    }

   static func regular(size: CGFloat) -> UIFont {
        return UIFont(name: "AvenirNext-Regular", size: size)!
    }
}
