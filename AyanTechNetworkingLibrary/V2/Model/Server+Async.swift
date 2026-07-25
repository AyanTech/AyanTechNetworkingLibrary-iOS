//
//  Server+Async.swift
//  AyanTechNetworkingLibrary
//

import Foundation

extension Server {
    class func sendRequest(req: ATRequest) async -> (Data?, URLResponse?, Error?) {
        logRequest(req)

        let request = URLRequestBuilder.make(from: req)

        do {
            let result = try await defaultUrlSession.data(for: request)
            logResponse(for: req, data: result.0, response: result.1)
            return (result.0, result.1, nil)
        } catch {
            logResponse(for: req, data: nil, response: nil)
            return (nil, nil, error)
        }
    }
}
