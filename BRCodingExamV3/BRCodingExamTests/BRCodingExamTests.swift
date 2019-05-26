//
//  BRCodingExamTests.swift
//  BRCodingExamTests
//
//  Created by rickb on 5/26/19.
//  Copyright © 2019 rickb. All rights reserved.
//

import XCTest

var appManager: AppManagerProtocol!

class BRCodingExamTests: XCTestCase {

    override func setUp() {
        let appConfiguration = AppConfiguration()
        let endpointCollection = LunchTymeAPICollection(baseURL: appConfiguration.env.restaurantsURL, apiVersion: nil)
        let restaurantNavigationController = RestaurantNavigationController()

        appManager = AppManager(endpointCollection: endpointCollection, sessionManager: SessionManager.default, restaurantNavigationController: restaurantNavigationController)
    }

    override func tearDown() {
    }

    func testRestuarantsJSON() {
        let expectation = XCTestExpectation(description: "Restaurants JSON")
        appManager.getRestaurants().done { _ in
            expectation.fulfill()
        }.catch { error in
            XCTFail(error.localizedDescription)
        }
        wait(for: [expectation], timeout: 60)
    }
}
