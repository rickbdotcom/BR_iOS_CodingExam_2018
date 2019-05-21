//
//
//
//
//  Created by rickb on 10/13/18.
//  Copyright © 2018 rickbdotcom LLC All rights reserved.
//

import UIKit
import ExtraKit
import PromiseKit

protocol AppManagerContainer: class {
    var appManager: AppManager? { get set }
}

final class AppManager: NSObject, Injectable {
    typealias Container = AppManagerContainer
    static var containerKeyPath: ContainerKeyPath { return \Container.appManager }

    let endpointCollection: LunchTymeAPICollection
    let sessionManager: SessionManager
    let restaurantNavigationController: RestaurantNavigationController
    private var restaurants: [Restaurant]?

    init(endpointCollection: LunchTymeAPICollection, sessionManager: SessionManager, restaurantNavigationController: RestaurantNavigationController) {
        self.endpointCollection = endpointCollection
        self.sessionManager = sessionManager
        self.restaurantNavigationController = restaurantNavigationController
    }

// for more sophisticated applications we'd could implement caching, data observers, paginated api, etc
    func getRestaurants() -> Promise<[Restaurant]> {
        return sessionManager.endpointRequest(endpointCollection, LunchTymeAPICollection.GetRestaurants(parameters: .none)).map {
            self.restaurants = $0.result.value?.restaurants
            return self.restaurants ?? []
        }
    }

    func showDetail(for restaurant: Restaurant?) {
        restaurantNavigationController.showDetail(for: restaurant)
    }

    func showRestaurantMap(with viewController: UIViewController) {
        let rvc = RestaurantMapViewController()
        rvc.canShowCallout = true
        rvc.restaurants = restaurants

        let nvc = UINavigationController(rootViewController: rvc)
        nvc.modalTransitionStyle = .flipHorizontal

       viewController.present(nvc, animated: true, completion: nil)
    }
}
