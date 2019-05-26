//
//  AppDelegate.swift
//  BRCodingExam
//
//  Created by rickb on 5/16/19.
//  Copyright © 2019 rickb. All rights reserved.
//

import UIKit
import ExtraKit

// This is a version of the app done more in the style of a "real-life" app.
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        initAppearance()
        initApp()
        return true
    }

    private func initApp() {
        let appConfiguration = AppConfiguration()
        let endpointCollection = LunchTymeAPICollection(baseURL: appConfiguration.env.restaurantsURL, apiVersion: nil)
        let restaurantNavigationController = RestaurantNavigationController(rootViewController: StoryboardLunch.List().instantiate())
        let webNavigationController = UINavigationController(rootViewController: WebViewController(with: appConfiguration.env.bottleRocketURL))

        let appManager = AppManager(endpointCollection: endpointCollection, sessionManager: SessionManager.default, restaurantNavigationController: restaurantNavigationController)
        setAppManager(appManager)

        window?.rootViewController = UITabBarController().configure {
            $0.viewControllers = [restaurantNavigationController, webNavigationController]
        }
    }
}
