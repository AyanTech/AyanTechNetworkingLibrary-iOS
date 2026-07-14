//
//  URLSession.swift
//  AyanTechNetworkingLibrary
//
//  Created by Sepehr Behroozi on 3/16/19.
//  Copyright © 2019 Ayantech. All rights reserved.
//

import Foundation

extension URLSession {
    func synchronousDataTask(with urlRequest: URLRequest) -> (Data?, URLResponse?, Error?) {
        let semaphore = DispatchSemaphore(value: 0)
        final class SyncDataTaskResult: @unchecked Sendable {
            var data: Data?
            var response: URLResponse?
            var error: Error?
        }
        let result = SyncDataTaskResult()

        let dataTask = self.dataTask(with: urlRequest) {
            result.data = $0
            result.response = $1
            result.error = $2
            semaphore.signal()
        }
        dataTask.resume()

        _ = semaphore.wait(timeout: .distantFuture)
        return (result.data, result.response, result.error)
    }
}
