//
//  Server.swift
//  InquirySDKLib
//
//  Created by Sepehr Behroozi on 6/25/18.
//  Copyright © 2018 Ayantech. All rights reserved.
//

import Foundation

internal let kResponseSuccessCode = "G00000"

class Server {
    static var logger: ATNetworkLogging = DefaultATNetworkLogger()
    
    fileprivate static var defaultUrlSession: URLSession = {
        var config = URLSessionConfiguration.default
        if ATRequest.Configuration.noProxy {
            config.connectionProxyDictionary = [:]
        }
        let result = URLSession(configuration: config)
        return result
    }()
    
    class func sendSyncRequest(req: ATRequest) -> (Data?, URLResponse?, Error?) {
        logger.logRequest(url: req.url, method: req.method, headers: req.headers, body: req.body)

        var request = URLRequest(url: URL(string: req.url)!, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: ATRequest.Configuration.timeout)
        request.httpMethod = req.method.rawValue
        req.headers.forEach { request.addValue($0.value, forHTTPHeaderField: $0.key) }
        request.httpBody = req.body
        
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
    
    class func sendRequest(req: ATRequest, responseHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
        logger.logRequest(url: req.url, method: req.method, headers: req.headers, body: req.body)

        var request = URLRequest(url: URL(string: req.url)!, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: ATRequest.Configuration.timeout)
        request.httpMethod = req.method.rawValue
        req.headers.forEach { request.addValue($0.value, forHTTPHeaderField: $0.key) }
        request.httpBody = req.body
        req.task = Server.defaultUrlSession.dataTask(with: request) { data, response, error in
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
