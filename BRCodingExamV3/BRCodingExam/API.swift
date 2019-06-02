//
//
//
//
//  Created by rickb on 10/13/18.
//  Copyright © 2018 rickbdotcom LLC All rights reserved.
//

import Foundation

// Obviously this is total overkill for just this one endpoint, but illustrative of the general approach I like to use for REST APIs
struct LunchTymeAPICollection: APIEndpointCollection {
    typealias CollectionEndpoint = LunchTymeAPIEndpoint
    let baseURL: URL
    let apiVersion: String?

    struct GetRestaurants: CollectionEndpoint {
        var endpoint: Endpoint { return .init("restaurants.json") }

        typealias Parameters = NoParameters
        struct Response: Decodable {
            let restaurants: [Restaurant]
        }
    }
}

protocol LunchTymeAPIEndpoint: APIEndpoint { }
