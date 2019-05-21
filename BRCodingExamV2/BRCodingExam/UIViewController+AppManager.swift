//
//
//
//
//  Created by rickb on 10/13/18.
//  Copyright © 2018 rickbdotcom LLC All rights reserved.
//

import UIKit

func useAppManagerUIKitInjection() {
	UIViewController.useAppManagerInjection()
	UINavigationController.useAppManagerInjection()
	UITabBarController.useAppManagerInjection()
	UIPageViewController.useAppManagerInjection()
}

extension UIViewController: AppManagerContainer {

	@objc var appManager: AppManager? {
		get { return associatedValue() }
		set { set(associatedValue: newValue) }
	}

	@objc class func useAppManagerInjection() {
		swizzle(instanceMethod: #selector(prepare(for:sender:)), with: #selector(appManager_prepare(for:sender:)))
		swizzle(instanceMethod: #selector(present(_:animated:completion:)), with: #selector(appManager_present(_:animated:completion:)))
		swizzle(instanceMethod: #selector(addChild(_:)), with: #selector(appManager_addChild(_:)))
	}

	@objc func appManager_prepare(for segue: UIStoryboardSegue, sender: Any?) {
		segue.destination.inject(value: appManager)
		appManager_prepare(for: segue, sender: sender)
	}

	@objc func appManager_present(_ viewController: UIViewController, animated: Bool, completion: (() -> Void)?) {
		viewController.inject(value: appManager)
		appManager_present(viewController, animated: animated, completion: completion)
	}

	@objc func appManager_addChild(_ viewController: UIViewController) {
		appManager_addChild(viewController)
		viewController.inject(value: appManager)
	}
}

extension UINavigationController {

	@objc override class func useAppManagerInjection() {
		swizzle(instanceMethod: #selector(setter: UINavigationController.appManager), with: #selector(appManager_setAppManager(_:)))
		swizzle(instanceMethod: #selector(setViewControllers(_:animated:)), with: #selector(appManager_setViewControllers(_:animated:)))
		swizzle(instanceMethod: #selector(pushViewController(_:animated:)), with: #selector(appManager_pushViewController(_:animated:)))
	}

	@objc func appManager_setAppManager(_ appManager: AppManager?) {
		appManager_setAppManager(appManager)
		injectIntoViewControllers()
	}

	@objc func appManager_setViewControllers(_ viewControllers: [UIViewController], animated: Bool) {
		appManager_setViewControllers(viewControllers, animated: animated)
		injectIntoViewControllers()
	}

	@objc func appManager_pushViewController(_ viewController: UIViewController, animated: Bool) {
		viewController.inject(value: appManager)
		appManager_pushViewController(viewController, animated: animated)
	}

	private func injectIntoViewControllers() {
		viewControllers.forEach {
			$0.inject(value: appManager)
		}
	}
}

extension UITabBarController {

	@objc override class func useAppManagerInjection() {
		swizzle(instanceMethod: #selector(setter: UITabBarController.appManager), with: #selector(appManager_setAppManager(_:)))
		swizzle(instanceMethod: #selector(setViewControllers(_:animated:)), with: #selector(appManager_setViewControllers(_:animated:)))
	}

	@objc func appManager_setAppManager(_ appManager: AppManager?) {
		appManager_setAppManager(appManager)
		injectIntoViewControllers()
	}

	@objc func appManager_setViewControllers(_ viewControllers: [UIViewController], animated: Bool) {
		appManager_setViewControllers(viewControllers, animated: animated)
		injectIntoViewControllers()
	}

	private func injectIntoViewControllers() {
		viewControllers?.forEach {
			$0.inject(value: appManager)
		}
	}
}

extension UIPageViewController {
	
	@objc override class func useAppManagerInjection() {
		swizzle(instanceMethod: #selector(setter: UIPageViewController.appManager), with: #selector(appManager_setAppManager(_:)))
		swizzle(instanceMethod: #selector(setViewControllers(_:direction:animated:completion:)), with: #selector(appManager_setViewControllers(_:direction:animated:completion:)))
	}
	
	@objc func appManager_setAppManager(_ appManager: AppManager?) {
		appManager_setAppManager(appManager)
		injectIntoViewControllers()
	}

	@objc func appManager_setViewControllers(_ viewControllers: [UIViewController]?, direction: UIPageViewController.NavigationDirection, animated: Bool, completion: ((Bool) -> Void)? = nil) {
		appManager_setViewControllers(viewControllers, direction: direction, animated: animated, completion: completion)
		injectIntoViewControllers()
	}
	
	private func injectIntoViewControllers() {
		viewControllers?.forEach {
			$0.inject(value: appManager)
		}
	}
}

