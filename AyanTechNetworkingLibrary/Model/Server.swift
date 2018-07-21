//
//  Server.swift
//  InquirySDKLib
//
//  Created by Sepehr Behroozi on 6/25/18.
//  Copyright © 2018 Ayantech. All rights reserved.
//

import Foundation
import Alamofire

internal let kResponseSuccessCode = "G00000"

class Server {
    class func sendRequest(req: ATRequest, responseHandler: @escaping (DataResponse<String>) -> Void) {
        ATLog("REQUEST", logData: "\(req.method.rawValue): \(req.url)")
        let params = defaultJsonParametersProcess(params: req.body)
        
        //print params
        do {
            let jsonStringData = try JSONSerialization.data(withJSONObject: params, options: JSONSerialization.WritingOptions.prettyPrinted)
            if let jsonString = String.init(data: jsonStringData, encoding: .utf8) {
                ATLog("PARAMS", logData: "\(jsonString)")
            }
        } catch {
            print(error.localizedDescription)
            ATLog("PARAMS", logData: "\(params)")
        }
        
        Utils.runOnMainThread {
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
        }
        Alamofire.request(req.url, method: req.method, parameters: params, encoding: req.encoding, headers: req.headers).responseString { (response) in
            Utils.runOnMainThread {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }
            if let responseString = String.init(data: response.data ?? Data(), encoding: .utf8) {
                ATLog("RESPONSE", logData: "\(responseString)")
            }
            responseHandler(response)
        }
    }
    
    class func defaultJsonParametersProcess(params: Parameters?) -> Parameters {
        var result = params ?? JSONObject()
        var identityParams = (result["Identity"] as? JSONObject) ?? JSONObject()
        identityParams["PackageName"] = "ios:" + (Bundle.main.bundleIdentifier ?? "")
        result["Identity"] = identityParams
        return result
    }
}
