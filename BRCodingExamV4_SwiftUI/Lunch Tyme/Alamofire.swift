//
//
//
//
//  Created by rickb on 10/13/18.
//  Copyright © 2018 rickbdotcom LLC All rights reserved.
//

import Foundation
import Alamofire
import CodableAlamofire
import Combine

extension SessionManager {

    func endpointRequest<T: APIEndpoint>(_ endpoint: T, baseURL: URL, parameters: T.Parameters? = nil, headers: [String: String]? = nil, encoder: JSONEncoder = JSONEncoder(), decoder: JSONDecoder = JSONDecoder()) -> Promise<DataResponse<T.Response>> {
		firstly {
			let urlRequest = try endpoint.request(baseURL: baseURL, parameters: parameters, headers: headers, encoder: encoder)
			return request(urlRequest).validate().debugLog().decodableObject(decoder: decoder)
		}
    }

    func dataEndpointRequest<T: APIEndpoint>(_ endpoint: T, baseURL: URL, parameters: T.Parameters? = nil, headers: [String: String]? = nil, encoder: JSONEncoder = JSONEncoder()) -> Promise<DefaultDataResponse> {
		firstly {
			let urlRequest = try endpoint.request(baseURL: baseURL, parameters: parameters, headers: headers, encoder: encoder)
			return request(urlRequest).validate().debugLog().data()
		}
    }
}

extension SessionManager {

    func endpointRequest<T: APIEndpoint, C: APIEndpointCollection>(_ collection: C, _ endpoint: T, _ parameters: T.Parameters? = nil, headers: [String: String]? = nil, encoder: JSONEncoder = JSONEncoder(), decoder: JSONDecoder = JSONDecoder()) -> Promise<DataResponse<T.Response>> {
        assert(collection.isCollectionEndpoint(endpoint))
        return endpointRequest(endpoint, baseURL: collection.apiBaseURL, parameters: parameters, headers: headers, encoder: encoder, decoder: decoder)
    }

    func dataEndpointRequest<T: APIEndpoint, C: APIEndpointCollection>(_ collection: C, _ endpoint: T, _ parameters: T.Parameters? = nil, headers: [String: String]? = nil, encoder: JSONEncoder = JSONEncoder()) -> Promise<DefaultDataResponse> {
        assert(collection.isCollectionEndpoint(endpoint))
        return dataEndpointRequest(endpoint, baseURL: collection.apiBaseURL, parameters: parameters, headers: headers, encoder: encoder)
    }
}

extension DataRequest {

	func decodableObject<T: Decodable>(decoder: JSONDecoder = JSONDecoder()) -> Promise<DataResponse<T>> {
		Promise { seal in
			self.responseDecodableObject(decoder: decoder) { (response: DataResponse<T>) in
				if let error = response.error {
					let dataResponse = DefaultDataResponse(request: response.request, response: response.response, data: response.data, error: response.error, timeline: response.timeline, metrics: response.metrics)
					seal(.failure(SessionManager.apiError?(dataResponse) ?? error))
				} else if response.value != nil {
					seal(.success(response))
				} else {
					seal(.failure(DataRequestError.invalidCallingConvention))
				}
			}
		}
	}

	func data() -> Promise<DefaultDataResponse> {
		Promise { seal in
			self.response { response in
				if let error = response.error {
					seal(.failure(SessionManager.apiError?(response) ?? error))
				} else if response.data != nil {
					seal(.success(response))
				} else {
					seal(.failure(DataRequestError.invalidCallingConvention))
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

enum DataRequestError: Error {
    case invalidCallingConvention
}

extension SessionManager {
	static var apiError: ((DefaultDataResponse) -> Error?)?
}

typealias HTTPMethod = Alamofire.HTTPMethod
typealias ParameterEncoding = Alamofire.ParameterEncoding
typealias URLRequestConvertible = Alamofire.URLRequestConvertible
typealias URLEncoding = Alamofire.URLEncoding
typealias JSONEncoding = Alamofire.JSONEncoding
typealias SessionManager = Alamofire.SessionManager
typealias ServerTrustPolicyManager = Alamofire.ServerTrustPolicyManager
typealias DataResponse = Alamofire.DataResponse
typealias DefaultDataResponse = Alamofire.DefaultDataResponse
