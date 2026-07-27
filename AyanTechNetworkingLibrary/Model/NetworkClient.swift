//
//  NetworkClient.swift
//  InquirySDKLib
//
//  Created by Sepehr Behroozi on 6/25/18.
//  Copyright © 2018 Ayantech. All rights reserved.
//

import Foundation

internal let kResponseSuccessCode = "G00000"

class NetworkClient {
    nonisolated(unsafe) static var logger: ATNetworkLogging = DefaultATNetworkLogger()
    
    static let defaultUrlSession: URLSession = makeDefaultSession()

    private static func makeDefaultSession() -> URLSession {
        let config = URLSessionConfiguration.default
        if ATRequest.Configuration.noProxy {
            config.connectionProxyDictionary = [:]
        }
        return URLSession(configuration: config)
    }
    
    class func sendSyncRequest(req: ATRequest) -> (Data?, URLResponse?, Error?) {
        logRequest(req)

        let request = req.buildURLRequest()
        let result = URLSession.shared.synchronousDataTask(with: request)

        logResponse(for: req, data: result.0, response: result.1)
        return result
    }
    
    class func sendRequest(req: ATRequest, responseHandler: @escaping @Sendable (Data?, URLResponse?, Error?) -> Void) {
        logRequest(req)

        let request = req.buildURLRequest()
        req.task = NetworkClient.defaultUrlSession.dataTask(with: request) { data, response, error in
            logResponse(for: req, data: data, response: response)

            Utils.runOnMainThread {
                req.task = nil
                responseHandler(data, response, error)
            }
        }
        req.task?.resume()
    }

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
