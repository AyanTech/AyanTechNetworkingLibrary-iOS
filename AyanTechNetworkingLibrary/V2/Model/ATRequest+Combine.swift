//
//  ATRequest+Combine.swift
//  AyanTechNetworkingLibrary
//

import Combine
import Foundation

public extension ATRequest {
    /// Always emits `ATResponse`. Inspect `response.error` for failures.
    @available(iOS 13.0, *)
    func responsePublisher() -> AnyPublisher<ATResponse, Never> {
        Deferred {
            Future { promise in
                let resolve = FuturePromise(promise: promise)
                Task {
                    let response = await self.send()
                    resolve.complete(with: .success(response))
                }
            }
        }
        .compactMap { response in
            response.error?.type == .cancelled ? nil : response
        }
        .eraseToAnyPublisher()
    }

    /// Emits only on success. Network and API errors are delivered as `Failure`.
    @available(iOS 13.0, *)
    func valuePublisher() -> AnyPublisher<ATResponse, ATError> {
        Deferred {
            Future<ATResponse, ATError> { promise in
                let resolve = FuturePromise(promise: promise)
                Task {
                    let response = await self.send()
                    if let error = response.error {
                        resolve.complete(with: .failure(error))
                    } else {
                        resolve.complete(with: .success(response))
                    }
                }
            }
        }
        .eraseToAnyPublisher()
    }
}

private struct FuturePromise<Output, Failure: Error>: @unchecked Sendable where Output: Sendable {
    private let promise: (Result<Output, Failure>) -> Void

    init(promise: @escaping (Result<Output, Failure>) -> Void) {
        self.promise = promise
    }

    func complete(with result: Result<Output, Failure>) {
        promise(result)
    }
}
