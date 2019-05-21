//
//  AppDelegate.swift
//  BRCodingExam
//
//  Created by rickb on 5/16/19.
//  Copyright © 2019 rickb. All rights reserved.
//

import UIKit

// wish we had a proper css style library on iOS but this is the best built-in thing we've got. I've toyed with various 3rd party styling libraries.
func initAppearance() {

    UINavigationBar.appearance().barTintColor = UIColor(named: "navBar")
    UINavigationBar.appearance().tintColor = .white
    UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.white, .font: UIFont.semiBold(size: 17.0)]

    UITabBar.appearance().barTintColor = UIColor(named: "tabBar")
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

extension UIColor {
    static var text: UIColor { return UIColor(red: 45/255.0, green: 45/255.0, blue: 45/255.0, alpha: 1) }
}

