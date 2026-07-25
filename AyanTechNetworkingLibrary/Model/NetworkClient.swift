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
    
    static let defaultUrlSession: URLSession = {
        URLSessionBuilder.makeDefaultSession()
    }()
    
    class func sendSyncRequest(req: ATRequest) -> (Data?, URLResponse?, Error?) {
        logger.logRequest(url: req.url, method: req.method, headers: req.headers, body: req.body)

        let request = URLRequestBuilder.build(from: req)
        
        let result = URLSession.shared.synchronousDataTask(with: request)

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
        return result
    }
    
    class func sendRequest(req: ATRequest, responseHandler: @escaping @Sendable (Data?, URLResponse?, Error?) -> Void) {
        logger.logRequest(url: req.url, method: req.method, headers: req.headers, body: req.body)

        let request = URLRequestBuilder.build(from: req)
        req.task = NetworkClient.defaultUrlSession.dataTask(with: request) { data, response, error in
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

            Utils.runOnMainThread {
                req.task = nil
                responseHandler(data, response, error)
            }
        }
        req.task?.resume()
    }
}
