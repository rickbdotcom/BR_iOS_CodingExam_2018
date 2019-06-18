//
//  SceneDelegate.swift
//  Lunch Tyme
//
//  Created by rickb on 6/5/19.
//  Copyright © 2019 rickb. All rights reserved.
//

import UIKit
import SwiftUI

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

	var window: UIWindow?

	func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
		let window = UIWindow(frame: UIScreen.main.bounds)
		window.rootViewController = UIHostingController(rootView: ContentView())
		self.window = window
		window.makeKeyAndVisible()
	}
}

