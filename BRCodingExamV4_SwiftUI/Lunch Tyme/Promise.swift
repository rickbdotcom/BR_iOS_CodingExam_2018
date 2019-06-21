//
//  Promise.swift
//  Lunch Tyme
//
//  Created by rickb on 6/20/19.
//  Copyright © 2019 rickb. All rights reserved.
//

import Combine

typealias Promise<T> = Publishers.Future<T, Error>

func firstly<T>(_ f: () throws -> Promise<T>) -> Promise<T> {
	do {
		return try f()
	} catch let error {
		return Promise { $0(.failure(error)) }
	}
}
