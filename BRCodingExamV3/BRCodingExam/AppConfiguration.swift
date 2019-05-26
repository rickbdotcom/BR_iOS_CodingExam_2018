//
//  AppConfiguration.swift
//  BRCodingExam
//
//  Created by rickb on 5/20/19.
//  Copyright © 2019 rickb. All rights reserved.
//

import Foundation

public struct AppConfiguration: Equatable {
	let rawValue: String

	public init(_ rawValue: Any?) {
#if DEBUG
		let defaultValue = "staging"
#else
		let defaultValue = "production"
#endif
		self.rawValue = (rawValue as? String)?.emptyNil ?? defaultValue
	}

	public init() {
		if let config = ProcessInfo.processInfo.environment["Config"] {
			self = AppConfiguration(config)
		} else {
			self = AppConfiguration(Bundle.main.infoDictionary?["Config"])
		}
	}
}

// predefined configurations
public extension AppConfiguration {
	static let production = AppConfiguration("production")
	static let staging = AppConfiguration("staging")
}

enum ConfigEnvironment {
    case staging
    case production

    var restaurantsURL: URL {
        switch self {
        case .staging: return URL(string: "https://s3.amazonaws.com/br-codingexams")!
        case .production: return URL(string: "https://s3.amazonaws.com/br-codingexams")!
        }
    }

    var bottleRocketURL: URL {
        switch self {
        case .staging: return URL(string: "https://www.bottlerocketstudios.com")!
        case .production: return URL(string: "https://www.bottlerocketstudios.com")!
        }
    }
}

extension AppConfiguration {

    var env: ConfigEnvironment {
        switch self {
            case .staging: return .staging
            case .production: return .production
            default: assertionFailure("unknown configuration"); return .staging
        }
    }
}

// staging build `APP_CONFIG=staging xcodebuild -workspace "BRCodingExam.xcworkspace" -scheme "BRCodingExam" archive`
