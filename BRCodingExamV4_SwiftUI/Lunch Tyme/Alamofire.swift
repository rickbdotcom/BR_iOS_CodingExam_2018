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

public extension SessionManager {
	static var apiError: ((DefaultDataResponse) -> Error?)?
}

public extension DataRequest {

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
