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

        NotificationCenter.default.addObserver(self, selector: #selector(showRestaurantDetail(_:)), name: .showRestaurantDetailNotification, object: nil)
    }

    @objc func showRestaurantDetail(_ note: Notification) {
        let vc = storyboard!.instantiateViewController(withIdentifier: "RestaurantDetail") as! RestaurantDetailViewController
        vc.restaurant = note.object as? Restaurant

        if viewControllers.count == 1 {
            pushViewController(vc, animated: true)
        } else if viewControllers.count > 1 {
            viewControllers = [viewControllers[0], vc]
        }
        presentedViewController?.dismiss(animated: true, completion: nil)
    }
}
