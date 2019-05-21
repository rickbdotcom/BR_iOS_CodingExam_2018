//
//  API.swift
//  BRCodingExam
//
//  Created by rickb on 5/20/19.
//  Copyright © 2019 rickb. All rights reserved.
//

import Foundation

extension URLSession {

// In a real app, I would define this endpoint with a struct describing the http method, parameters and response, and it would return the decoded object as Promise
    func getRestaurants(_ completion: @escaping (RestaurantsResponse?, Error?) -> Void) -> URLSessionTask { // completion handlers are the worst, Promises4Ever!
        return decodeTask(with: URL(string: "https://s3.amazonaws.com/br-codingexams/restaurants.json")!) { (response: RestaurantsResponse?, error: Error?) in
            restaurants = response?.restaurants
            completion(response, error)
        }
    }
}

extension URLSession {

    func decodeTask<T: Decodable>(with url: URL, _ completion: @escaping(T?, Error?) -> Void) -> URLSessionTask {
        return dataTask(with: url) { data, _ , error in
            DispatchQueue.main.async {
                do {
                    if let error = error { throw error }
                    guard let data = data else { throw NSError(domain: "com.rickb", code: -1, userInfo: [NSLocalizedDescriptionKey: "Null data"]) }

                    let response = try JSONDecoder().decode(T.self, from: data)
                    completion(response, nil)
                } catch let error {
                    print(error)
                    completion(nil, error)
                }
            }
        }
    }
}

// typically I'd define this as part of a larger struct representing the API endpoint which would encapsulate the parameters, response, http method, etc.
struct RestaurantsResponse: Decodable {
    let restaurants: [Restaurant]
}

// just a simple global to store resturant list for use with map controller
var restaurants: [Restaurant]?
