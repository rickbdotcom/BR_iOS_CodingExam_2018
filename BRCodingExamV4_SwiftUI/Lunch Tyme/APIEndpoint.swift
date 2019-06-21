//
//
//
//
//  Created by rickb on 10/13/18.
//  Copyright © 2018 rickbdotcom LLC All rights reserved.
//

import Foundation

protocol APIEndpoint {

	var endpoint: Endpoint { get }

	associatedtype Parameters: Encodable
	associatedtype Response: Decodable
}

extension APIEndpoint {

    func request(baseURL: URL, parameters: Parameters?, headers: [String: String]?, encoder: JSONEncoder) throws -> URLRequest {
        return try endpoint.request(baseURL: baseURL, parameters: parameters, headers: headers, encoder: encoder)
    }
}

struct Endpoint {
	let path: String
	let method: HTTPMethod
	let encoding: ParameterEncoding?
	
	init(_ path: String, _ method: HTTPMethod = .get, encoding: ParameterEncoding? = nil) {
		self.path = path
		self.method = method
		self.encoding = encoding
	}

    func request<T: Encodable>(baseURL: URL, parameters: T?, headers: [String: String]?, encoder: JSONEncoder) throws -> URLRequest {
		var url = baseURL
		url.appendPathComponent(path)
		
		var request = URLRequest(url: url)
		request.httpMethod = method.rawValue
		
		if let headers = headers {
			for (headerField, headerValue) in headers {
				request.setValue(headerValue, forHTTPHeaderField: headerField)
			}
		}

		func parameterJSON() throws -> [String: Any]? {
			guard let parameters = parameters else { return nil }
			let data = try encoder.encode(parameters)
			return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
		}

		return try (encoding ?? defaultEncoding).encode(request, with: parameterJSON())
	}

	var defaultEncoding: ParameterEncoding {
		return method == .get ? URLEncoding.default : JSONEncoding.default
	}
}

struct UnimplementedEndpoint: APIEndpoint {
	var endpoint: Endpoint { assertionFailure("unimplemented"); return .init("") }
	let parameters: Parameters?

	typealias Parameters = NoParameters
	typealias Response = EmptyResponse
}

struct NoParameters: Encodable {
	init() { }
	static var none: NoParameters { return .init() }
}

struct EmptyResponse: Decodable {
	init() { }
	static var empty: EmptyResponse { return .init() }
}

protocol APIEndpointCollection {
	var baseURL: URL { get }
	var apiVersion: String? { get }

	associatedtype CollectionEndpoint

    func isCollectionEndpoint<T: APIEndpoint>(_ endpoint: T) -> Bool
}

extension APIEndpointCollection {

    func isCollectionEndpoint<T: APIEndpoint>(_ endpoint: T) -> Bool {
        return endpoint is CollectionEndpoint
    }

	var apiBaseURL: URL {
		var baseURL = self.baseURL
		if let apiVersion = self.apiVersion {
			baseURL.appendPathComponent(apiVersion)
		}
		return baseURL
	}
}
