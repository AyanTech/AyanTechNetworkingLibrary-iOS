//
//  Server+Logging.swift
//  AyanTechNetworkingLibrary
//

import Foundation

extension Server {
    class func logRequest(_ req: ATRequest) {
        logger.logRequest(url: req.url, method: req.method, headers: req.headers, body: req.body)
    }

    class func logResponse(for req: ATRequest, data: Data?, response: URLResponse?) {
        let responseCode = (response as? HTTPURLResponse)?.statusCode ?? -1
        let responseHeaders = ((response as? HTTPURLResponse)?.allHeaderFields as? [String: String]) ?? [:]
        logger.logResponse(
            requestUrl: req.url,
            requestMethod: req.method,
            requestHeaders: req.headers,
            requestBody: req.body,
            responseCode: responseCode,
            responseHeaders: responseHeaders,
            responseBody: data
        )
    }
}
