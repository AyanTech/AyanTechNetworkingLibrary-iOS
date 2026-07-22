//
//  ATResponse.swift
//  InquirySDKLib
//
//  Created by Sepehr Behroozi on 6/25/18.
//  Copyright © 2018 Ayantech. All rights reserved.
//

import Foundation

public struct ATResponse: Sendable {
    public var responseString: String?
    public var error: ATError?
    public var status: Status?
    public var responseCode = -1
    public var headers = [String: String]()

    public init() {}

    public var parametersJsonObject: JSONObject? {
        return getJsonObject(responseJsonObject, ["Parameters"])
    }

    public var parametersJsonArray: JSONArray? {
        return getJsonArray(responseJsonObject, ["Parameters"])
    }

    public var responseJsonObject: JSONObject? {
        if let data = responseString?.data(using: .utf8) {
            do {
                let result = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                return result as? JSONObject
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }

    public var isSuccess: Bool {
        return status?.isSuccess ?? false
    }

    static func from(mockFilePath: String) -> (ATResponse, Double) {
        var result = ATResponse()
        var delay: Double = 0
        if let fileInputStream = InputStream(fileAtPath: mockFilePath) {
            fileInputStream.open()
            if let mockJson = (try? JSONSerialization.jsonObject(with: fileInputStream, options: .allowFragments) as? JSONObject) {
                if let headers = getJsonObject(mockJson, ["headers"]) {
                    headers.forEach {
                        result.headers[$0] = String(describing: $1)
                    }
                }
                if let bodyString = getString(mockJson, ["body"]) {
                    result.responseString = bodyString
                } else if let bodyJsonObject = getJsonObject(mockJson, ["body"]), let bodyString = String(data: (try? JSONSerialization.data(withJSONObject: bodyJsonObject, options: .prettyPrinted)) ?? Data(), encoding: .utf8) {
                    result.responseString = bodyString
                } else if let bodyJsonArray = getJsonArray(mockJson, ["body"]), let bodyString = String(data: (try? JSONSerialization.data(withJSONObject: bodyJsonArray, options: .prettyPrinted)) ?? Data(), encoding: .utf8) {
                    result.responseString = bodyString
                } else {
                    result.error = .generalError
                }
                result.status = Status.from(json: getJsonObject(result.responseJsonObject, ["Status"]))
                result.responseCode = getInt(mockJson, ["meta", "statusCode"]) ?? 200
                delay = getDouble(mockJson, ["meta", "delay"]) ?? 0
            } else {
                result.error = .generalError
            }
        } else {
            result.error = .generalError
        }

        return (result, delay)
    }

    static func from(responseData: Data?, responseHeaders: URLResponse?, responseError: Error?) -> ATResponse {
        var result = ATResponse()
        let responseHeaders = (responseHeaders as? HTTPURLResponse)
        result.responseCode = responseHeaders?.statusCode ?? -1
        responseHeaders?.allHeaderFields.forEach { key, value in
            result.headers[String(describing: key)] = String(describing: value)
        }
        if result.responseCode / 10 == 20 {
            if let data = responseData, let jsonString = String(data: data, encoding: .utf8) {
                result.responseString = jsonString
            }
            result.status = Status.from(json: getJsonObject(result.responseJsonObject, ["Status"]))
            result.error = ATError.from(status: result.status)
        } else {
            result.responseString = nil
            result.status = nil
            result.error = ATError.from(error: responseError)
        }
        if result.status?.errorCodeString == Status.tokenExpiredCode {
            NotificationCenter.default.post(name: NSNotification.Name.tokenExpiredReceived, object: nil)
        }
        return result
    }

    public struct Status: Sendable {
        public var errorCodeString: String?
        public var description: String?

        public static var tokenExpiredCode: String {
            return "G00002"
        }

        public init() {}

        public var isSuccess: Bool {
            return errorCodeString == kResponseSuccessCode
        }

        static func from(json object: JSONObject?) -> Status? {
            guard let object = object else {
                return nil
            }
            var result = Status()
            result.errorCodeString = getString(object, ["Code"])
            result.description = getString(object, ["Description"])
            return result
        }
    }
}
