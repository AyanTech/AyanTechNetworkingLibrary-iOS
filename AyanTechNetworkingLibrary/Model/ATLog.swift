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
        var logContent = "🌐 AT-Log-REQUEST ===> \(method.rawValue) - \(url)"
        if let body = body {
            if let json = try? JSONSerialization.jsonObject(with: body, options: []),
               let data = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted),
               let jsonString = String(data: data, encoding: .utf8) {
                logContent += "\n" + "Params: \(jsonString)"
            } else {
                logContent += "\n" + "Params: \(String(data: body, encoding: .utf8) ?? "Invalid JSON")"
            }
        }
        print(logContent)
    }

    func logResponse(requestUrl: String, requestMethod: HTTPMethod, requestHeaders: [String: String], requestBody: Data?, responseCode: Int, responseHeaders: [String: String]?, responseBody: Data?) {
        var logContent = "🌐 AT-Log-RESPONSE ===> \(responseCode) - \(requestUrl)"
        if let responseBody = responseBody {
            if let json = try? JSONSerialization.jsonObject(with: responseBody, options: []),
               let data = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted),
               let jsonString = String(data: data, encoding: .utf8) {
                logContent += "\n" + jsonString
            } else {
                logContent += "\n" + (String(data: responseBody, encoding: .utf8) ?? "Invalid JSON")
            }
        }
        print(logContent)
    }
}
