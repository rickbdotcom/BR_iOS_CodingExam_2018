//
//  AppController.swift
//  Lunch Tyme
//
//  Created by rickb on 6/20/19.
//  Copyright © 2019 rickb. All rights reserved.
//

import UIKit
import Combine
import SwiftUI

class AppController: BindableObject {
	let didChange = PassthroughSubject<Void, Never>()
	let restaurantsModel = RestaurantsModel()
	let appConfiguration = AppConfiguration()
	let sessionManager = SessionManager.default
	lazy var api = LunchTymeAPICollection(baseURL: appConfiguration.env.restaurantsURL, apiVersion: nil)

	init() {
		fetchRestaurants()
	}

	private func fetchRestaurants() {
		_ = sessionManager.endpointRequest(api, LunchTymeAPICollection.GetRestaurants()).sink { result in
			self.restaurantsModel.restaurants = result.value?.restaurants ?? []
		}
	}
}
class RestaurantsModel: BindableObject {
	let didChange = PassthroughSubject<Void, Never>()
	var restaurants = [Restaurant]() {
		didSet {
			didChange.send(())
		}
	}
}
