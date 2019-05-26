//
//  RestaurantsNavigationController.swift
//  BRCodingExam
//
//  Created by rickb on 5/20/19.
//  Copyright © 2019 rickb. All rights reserved.
//

import UIKit

class RestaurantNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        tabBarItem = UITabBarItem(title: .tab_lunch, image: .tab_lunch, tag: 0)
    }

    func showDetail(for restaurant: Restaurant?) {
        guard let restaurant = restaurant else { return }
        let rvc = StoryboardLunch.Detail().instantiate()
        rvc.restaurant = restaurant

        if viewControllers.count == 1 {
            pushViewController(rvc, animated: true)
        } else if viewControllers.count > 1 {
            viewControllers = [viewControllers[0], rvc]
        }
        presentedViewController?.dismiss(animated: true, completion: nil)
    }
}
