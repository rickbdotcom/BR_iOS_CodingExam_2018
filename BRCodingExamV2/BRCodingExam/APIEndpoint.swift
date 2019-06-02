//
//
//
//
//  Created by rickb on 10/13/18.
//  Copyright © 2018 rickbdotcom LLC All rights reserved.
//

import Foundation

public protocol APIEndpoint {

	var endpoint: Endpoint { get }

	associatedtype Parameters: Encodable
	associatedtype Response: Decodable
}

public extension APIEndpoint {

    func request(baseURL: URL, parameters: Parameters?, headers: [String: String]?, encoder: JSONEncoder) throws -> URLRequest {
        return try endpoint.request(baseURL: baseURL, parameters: parameters, headers: headers, encoder: encoder)
    }
}

public struct Endpoint {
	public let path: String
	public let method: HTTPMethod
	public let encoding: ParameterEncoding?
	
	public init(_ path: String, _ method: HTTPMethod = .get, encoding: ParameterEncoding? = nil) {
		self.path = path
		self.method = method
		self.encoding = encoding
	}

    public func request<T: Encodable>(baseURL: URL, parameters: T?, headers: [String: String]?, encoder: JSONEncoder) throws -> URLRequest {
		var url = baseURL
		url.appendPathComponent(path)
		
		var request = URLRequest(url: url)
		request.httpMethod = method.rawValue
		
		if let headers = headers {
			for (headerField, headerValue) in headers {
				request.setValue(headerValue, forHTTPHeaderField: headerField)
			}
		}
		return try (encoding ?? defaultEncoding).encode(request, with: parameters.toJSON(encoder: encoder) as? [String: Any])
	}

	public var defaultEncoding: ParameterEncoding {
		return method == .get ? URLEncoding.default : JSONEncoding.default
	}
}

public struct UnimplementedEndpoint: APIEndpoint {
	public var endpoint: Endpoint { assertionFailure("unimplemented"); return .init("") }
	public let parameters: Parameters?

	public typealias Parameters = NoParameters
	public typealias Response = EmptyResponse
}

public struct NoParameters: Encodable {
	public init() { }
	public static var none: NoParameters { return .init() }
}

public struct EmptyResponse: Decodable {
	public init() { }
	public static var empty: EmptyResponse { return .init() }
}

public protocol APIEndpointCollection {
	var baseURL: URL { get }
	var apiVersion: String? { get }

	associatedtype CollectionEndpoint

    func isCollectionEndpoint<T: APIEndpoint>(_ endpoint: T) -> Bool
}

public extension APIEndpointCollection {

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
