//
//
//
//
//  Created by rickb on 10/13/18.
//  Copyright © 2018 rickbdotcom LLC All rights reserved.
//

import PromiseKit

public extension Promise {

	static func void() -> Promise<Void> {
		return .value(())
	}
	
	static func `nil`<T>() -> Promise<T?> {
		return .value(nil)
	}
	
	static func empty<T>() -> Promise<[T]> {
		return .value([])
	}
	
	static func cancelled<T>() -> Promise<T> {
		return Promise<T>(error: PMKError.cancelled)
	}
}

public extension Guarantee {

	static func void() -> Promise<Void> {
		return .value(())
	}

	static func `nil`<T>() -> Promise<T?> {
		return .value(nil)
	}

	static func empty<T>() -> Promise<[T]> {
		return .value([])
	}
}

public class ResolverArray<T> {
	
	private var resolvers = [Resolver<T>]()

	public var isEmpty: Bool { return resolvers.isEmpty }

	public init() { }

	public func add() -> Promise<T> {
		let (promise, seal) = Promise<T>.pending()
		resolvers.append(seal)
		return promise
	}
	
	public func fulfill(_ value: T) {
		resolvers.forEach {
			$0.fulfill(value)
		}
		resolvers = []
	}

	public func reject(_ error: Error) {
		resolvers.forEach {
			$0.reject(error)
		}
		resolvers = []
	}

	public func resolve(_ result: PromiseKit.Result<T>) {
		resolvers.forEach {
			$0.resolve(result)
		}
		resolvers = []
	}

	deinit {
		reject((PMKError.cancelled))
	}
}

public extension Promise {

	func resolve(with resolvers: ResolverArray<T>) -> Promise {
		return tap {
			resolvers.resolve($0)
		}
	}
}

public extension PromiseKit.Result {

	var value: T? {
		switch self {
		case let .fulfilled(value): return value
		case .rejected: return nil
		}
	}

	var error: Error? {
		switch self {
		case .fulfilled: return nil
		case let .rejected(error): return error
		}
	}
}

/// A cancel token for use with promises
///
///		weak var cancelToken = newCancelToken(&self.cancelToken)
///		return nextPage(currentPage).map { [weak self] (items, eol) in
///			try cancelToken.throwIfCancelled()

public protocol CancelTokenProtocol {

	var isCancelled: Bool { get }

	func cancel()

	init()
}

public extension CancelTokenProtocol {

	func throwIfCancelled() throws {
		if isCancelled {
			throw PMKError.cancelled
		}
	}
}

public final class CancelToken: CancelTokenProtocol {

	public private(set) var isCancelled = false

	public func cancel() {
		isCancelled = true
	}

	public init() { }
}

public final class SemaphoreCancelToken: CancelTokenProtocol {

	private let semaphore = DispatchSemaphore(value: 0)
	public private(set) var isCancelled = false

	public func cancel() {
		isCancelled = true
		semaphore.signal()
	}

	public func wait() {
		semaphore.wait()
	}

	public init() {}

	deinit {
		semaphore.signal()
	}
}

public extension Optional where Wrapped: CancelTokenProtocol {

	/// CancelToken is often accessed through its Optional so we can throw when weak reference is nil'ed out.
	/// This method throws if CancelToken has be cancelled or weak reference is nil'ed out, for use in Promise body.
	func throwIfCancelled() throws {
		switch self {
		case .none:
			throw PMKError.cancelled
		case .some(let token):
			try token.throwIfCancelled()
		}
	}

	var isCancelled: Bool {
		return self?.isCancelled ?? true
	}
}

/// Cancel current token and assign a new value
@discardableResult public func newCancelToken<T: CancelTokenProtocol>(_ token: inout T?) -> T? {
	token?.cancel()
	token = T()
	return token
}

/// Unwrap weak Optionals and throw cancel if nil
///		weak var cancelToken = newCancelToken(&self.cancelToken)
///		return nextPage(currentPage).map { [weak self] (items, eol) in
///			let `self` = try self.throwUnwrap()
public extension Optional {

	func throwUnwrap() throws -> Wrapped {
		switch self {
		case .none:
			throw PMKError.cancelled
		case .some(let value):
			return value
		}
	}
}
