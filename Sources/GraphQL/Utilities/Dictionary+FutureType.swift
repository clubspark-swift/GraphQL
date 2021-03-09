//
//  DictionaryFuture.swift
//  GraphQL
//
//  Created by Jeff Seibert on 3/9/18.
//

import Foundation
import NIO

public protocol FutureType {
    /// This future's expectation.
    associatedtype Expectation

    /// This future's result type.
    typealias Result = FutureResult<Expectation>

    /// The event loop this future is fulfilled on.
    var eventLoop: EventLoop { get }

    /// Adds a new awaiter to this `Future` that will be called when the result is ready.
    func addAwaiter(callback: @escaping FutureResultCallback<Expectation>)
}

public typealias FutureResultCallback<T> = (FutureResult<T>) -> ()

public indirect enum FutureResult<T> {
    case error(Error)
    case success(T)

    /// Returns the result error or `nil` if the result contains expectation.
    public var error: Error? {
        switch self {
        case .error(let error):
            return error
        default:
            return nil
        }
    }

    /// Returns the result expectation or `nil` if the result contains an error.
    public var result: T? {
        switch self {
        case .success(let expectation):
            return expectation
        default:
            return nil
        }
    }

    /// Throws an error if this contains an error, returns the Expectation otherwise
    public func unwrap() throws -> T {
        switch self {
        case .success(let data):
            return data
        case .error(let error):
            throw error
        }
    }
}

extension Dictionary where Value: FutureType {
    func flatten(on worker: EventLoopGroup) -> EventLoopFuture<[Key: Value.Expectation]> {
        var elements: [Key: Value.Expectation] = [:]

        guard self.count > 0 else {
            return worker.next().makeSucceededFuture(elements)
        }

        let promise: EventLoopPromise<[Key: Value.Expectation]> = worker.next().makePromise()
        elements.reserveCapacity(self.count)

        for (key, value) in self {
            value.addAwaiter { result in
                switch result {
                case .error(let error): promise.fail(error)
                case .success(let expectation):
                    elements[key] = expectation

                    if elements.count == self.count {
                        promise.succeed(elements)
                    }
                }
            }
        }

        return promise.futureResult
    }
}
