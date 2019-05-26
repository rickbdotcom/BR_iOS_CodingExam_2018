//
//
//
//
//  Created by rickb on 10/13/18.
//  Copyright © 2018 rickbdotcom LLC All rights reserved.
//

import Alamofire
import CodableAlamofire
import PromiseKit

public extension SessionManager {

	func endpointRequest<T: APIEndpoint>(_ endpoint: T, baseURL: URL, headers: [String: String]? = nil, encoder: JSONEncoder = JSONEncoder(), decoder: JSONDecoder = JSONDecoder()) -> Promise<DataResponse<T.Response>> {
		return firstly { () -> Promise<DataResponse<T.Response>> in
			let urlRequest = try endpoint.request(baseURL: baseURL, headers: headers, encoder: encoder)
			return request(urlRequest).validate().debugLog().decodableObject(decoder: decoder)
		}
	}
	
	func dataEndpointRequest<T: APIEndpoint>(_ endpoint: T, baseURL: URL, headers: [String: String]? = nil, encoder: JSONEncoder = JSONEncoder()) -> Promise<DefaultDataResponse> {
		return firstly { () -> Promise<DefaultDataResponse> in
			let urlRequest = try endpoint.request(baseURL: baseURL, headers: headers, encoder: encoder)
			return request(urlRequest).validate().debugLog().data()
		}
	}
}

public extension SessionManager {

// I wish I could actually constrain APIEndpoint to APIEndpointCollection.CollectionEndpoint but Swift doesn't allow it
	func endpointRequest<T: APIEndpoint, C: APIEndpointCollection>(_ collection: C, _ endpoint: T, headers: [String: String]? = nil, encoder: JSONEncoder = JSONEncoder(), decoder: JSONDecoder = JSONDecoder()) -> Promise<DataResponse<T.Response>> {
		assert(collection.isValid(endpoint: endpoint)) // so we have this runtime assert instead
		return endpointRequest(endpoint, baseURL: collection.apiBaseURL, headers: headers, encoder: encoder, decoder: decoder)
	}

	func dataEndpointRequest<T: APIEndpoint, C: APIEndpointCollection>(_ collection: C, _ endpoint: T, headers: [String: String]? = nil, encoder: JSONEncoder = JSONEncoder()) -> Promise<DefaultDataResponse> {
		assert(collection.isValid(endpoint: endpoint))
		return dataEndpointRequest(endpoint, baseURL: collection.apiBaseURL, headers: headers, encoder: encoder)
	}
}

public extension SessionManager {
	static var apiError: ((DefaultDataResponse) -> Error?)?
}

public extension DataRequest {
	
	func decodableObject<T: Decodable>(decoder: JSONDecoder = JSONDecoder()) -> Promise<DataResponse<T>> {
		return Promise<DataResponse<T>> { seal in
			return self.responseDecodableObject(decoder: decoder) { (response: DataResponse<T>) in
				if let error = response.error {
					let dataResponse = DefaultDataResponse(request: response.request, response: response.response, data: response.data, error: response.error, timeline: response.timeline, metrics: response.metrics)
					seal.reject(SessionManager.apiError?(dataResponse) ?? error)
				} else if response.value != nil {
					seal.fulfill(response)
				} else {
					seal.reject(PMKError.invalidCallingConvention)
				}
			}
		}
	}

	func data() -> Promise<DefaultDataResponse> {
		return Promise<DefaultDataResponse> { seal in
			return self.response { response in
				if let error = response.error {
					seal.reject(SessionManager.apiError?(response) ?? error)
				} else if response.data != nil {
					seal.fulfill(response)
				} else {
					seal.reject(PMKError.invalidCallingConvention)
				}
			}
		}
	}

	func debugLog() -> DataRequest {
#if DEBUG
		if ProcessInfo.processInfo.environment["debugLog"] != nil {
			print(debugDescription) // cURL
		}
#endif
		return self
	}
}

public typealias HTTPMethod = Alamofire.HTTPMethod
public typealias ParameterEncoding = Alamofire.ParameterEncoding
public typealias URLRequestConvertible = Alamofire.URLRequestConvertible
public typealias URLEncoding = Alamofire.URLEncoding
public typealias JSONEncoding = Alamofire.JSONEncoding
public typealias SessionManager = Alamofire.SessionManager
public typealias ServerTrustPolicyManager = Alamofire.ServerTrustPolicyManager
public typealias DataResponse = Alamofire.DataResponse
public typealias DefaultDataResponse = Alamofire.DefaultDataResponse
