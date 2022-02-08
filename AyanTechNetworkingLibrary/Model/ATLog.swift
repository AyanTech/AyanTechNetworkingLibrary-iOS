//
//  RJLog.swift
//  Raja
//
//  Created by Sepehr Behroozi on 6/23/18.
//  Copyright © 2018 Ayantech. All rights reserved.
//

import Foundation

var verbose = true

public protocol ATNetworkLogging {
    func logRequest(url: String, method: HTTPMethod, headers: [String: String], body: Data?)
    func logResponse(requestUrl: String, requestMethod: HTTPMethod, requestHeaders: [String: String], requestBody: Data?, responseCode: Int, responseHeaders: [String: String]?, responseBody: Data?)
}

class DefaultATNetworkLogger: ATNetworkLogging {
    func logRequest(url: String, method: HTTPMethod, headers: [String: String], body: Data?) {
        var logContent = "AT-Log-REQUEST ===> \(method.rawValue) - \(url)"
        if let jsonString = String.init(data: body ?? Data(), encoding: .utf8) {
            logContent += "\n" + "Params: \(jsonString)"
        }
        print(logContent)
    }

    func logResponse(requestUrl: String, requestMethod: HTTPMethod, requestHeaders: [String: String], requestBody: Data?, responseCode: Int, responseHeaders: [String: String]?, responseBody: Data?) {
        var logContent = "AT-Log-RESPONSE ===> \(responseCode) - \(requestUrl)"
        if let responseString = String.init(data: responseBody ?? Data(), encoding: .utf8) {
            logContent += "\n" + responseString
        }
        print(logContent)
    }
}