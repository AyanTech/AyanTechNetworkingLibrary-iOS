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
        var data: Data?
        var error: Error?
        var response: URLResponse?

        let semaphore = DispatchSemaphore(value: 0)
        let dataTask = self.dataTask(with: urlRequest) {
            data = $0
            response = $1
            error = $2
            semaphore.signal()
        }
        dataTask.resume()

        _ = semaphore.wait(timeout: .distantFuture)
        return (data, response, error)
    }
}
