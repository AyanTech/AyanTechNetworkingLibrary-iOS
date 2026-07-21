//
//  Server+Async.swift
//  AyanTechNetworkingLibrary
//

import Foundation

extension Server {
    class func sendRequest(req: ATRequest) async -> (Data?, URLResponse?, Error?) {
        logger.logRequest(url: req.url, method: req.method, headers: req.headers, body: req.body)

        let request = URLRequestBuilder.make(from: req)

        do {
            let result = try await defaultUrlSession.data(for: request)
            let responseCode = (result.1 as? HTTPURLResponse)?.statusCode ?? -1
            let responseHeaders = ((result.1 as? HTTPURLResponse)?.allHeaderFields as? [String: String]) ?? [:]
            logger.logResponse(
                requestUrl: req.url,
                requestMethod: req.method,
                requestHeaders: req.headers,
                requestBody: req.body,
                responseCode: responseCode,
                responseHeaders: responseHeaders,
                responseBody: result.0
            )
            return (result.0, result.1, nil)
        } catch {
            logger.logResponse(
                requestUrl: req.url,
                requestMethod: req.method,
                requestHeaders: req.headers,
                requestBody: req.body,
                responseCode: -1,
                responseHeaders: [:],
                responseBody: nil
            )
            return (nil, nil, error)
        }
    }
}
