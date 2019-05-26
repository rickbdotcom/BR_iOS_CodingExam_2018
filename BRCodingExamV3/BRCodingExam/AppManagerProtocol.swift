//
//
//
//
//  Created by rickb on 10/13/18.
//  Copyright © 2018 rickbdotcom LLC All rights reserved.
//

import UIKit
import PromiseKit

protocol AppManagerProtocol {
    func getRestaurants() -> Promise<[Restaurant]>
    func showDetail(for restaurant: Restaurant?)
    func showRestaurantMap(with viewController: UIViewController)
}
