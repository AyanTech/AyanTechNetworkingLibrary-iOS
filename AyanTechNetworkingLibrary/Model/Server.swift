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
    
    class func sendRequest(req: ATRequest, responseHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
        ATLog("REQUEST", logData: "\(req.method.rawValue): \(req.url)")
        if let jsonString = String.init(data: req.body ?? Data(), encoding: .utf8) {
            ATLog("PARAMS", logData: "\(jsonString)")
        }
        Utils.runOnMainThread {
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
        }
        
        let r = NSMutableURLRequest(url: URL(string: req.url)!, cachePolicy: NSURLRequest.CachePolicy.reloadIgnoringLocalCacheData, timeoutInterval: 10)
        r.httpMethod = req.method.rawValue
        req.headers.forEach { r.addValue($0.value, forHTTPHeaderField: $0.key) }
        r.httpBody = req.body
        req.task = URLSession.shared.dataTask(with: r as URLRequest) { (data, response, error) in
            Utils.runOnMainThread {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                
                if let responseString = String.init(data: data ?? Data(), encoding: .utf8) {
                    ATLog("RESPONSE", logData: "\(responseString)")
                }
                
                req.task = nil
                responseHandler(data, response, error)
            }
        }
        req.task?.resume()
    }

    class func defaultJsonParametersProcess(params: JSONObject?) -> JSONObject {
        var result = params ?? JSONObject()
        var identityParams = (result["Identity"] as? JSONObject) ?? JSONObject()
        identityParams["PackageName"] = "ios:" + (Bundle.main.bundleIdentifier ?? "")
        result["Identity"] = identityParams
        return result
    }
    
    // MARK: - URLSessionDelegate
    
}
