//
//  Server.swift
//  InquirySDKLib
//
//  Created by Sepehr Behroozi on 6/25/18.
//  Copyright © 2018 Ayantech. All rights reserved.
//

import UIKit

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
        Utils.runOnMainThread {
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
        }
        
        let r = NSMutableURLRequest(url: URL(string: req.url)!, cachePolicy: NSURLRequest.CachePolicy.reloadIgnoringLocalCacheData, timeoutInterval: ATRequest.Configuration.timeout)
        r.httpMethod = req.method.rawValue
        req.headers.forEach { r.addValue($0.value, forHTTPHeaderField: $0.key) }
        r.httpBody = req.body
        
        let result = URLSession.shared.synchronousDataTask(with: r as URLRequest)
        
        Utils.runOnMainThread {
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }

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
        Utils.runOnMainThread {
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
        }
        
        let r = NSMutableURLRequest(url: URL(string: req.url)!, cachePolicy: NSURLRequest.CachePolicy.reloadIgnoringLocalCacheData, timeoutInterval: ATRequest.Configuration.timeout)
        r.httpMethod = req.method.rawValue
        req.headers.forEach { r.addValue($0.value, forHTTPHeaderField: $0.key) }
        r.httpBody = req.body
        req.task = Server.defaultUrlSession.dataTask(with: r as URLRequest) { (data, response, error) in
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
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                
                req.task = nil
                responseHandler(data, response, error)
            }
        }
        req.task?.resume()
    }
}
