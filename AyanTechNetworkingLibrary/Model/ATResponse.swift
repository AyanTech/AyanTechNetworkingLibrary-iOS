//
//  ATResponse.swift
//  InquirySDKLib
//
//  Created by Sepehr Behroozi on 6/25/18.
//  Copyright © 2018 Ayantech. All rights reserved.
//

import Foundation

public class ATResponse {
    public var responseString: String?
    public var error: ATError?
    public var status: Status?
    public var responseCode = -1
    public var headers = [AnyHashable: Any]()
    public var parametersJsonObject: JSONObject? {
        return getJsonObject(responseJsonObject, ["Parameters"])
    }
    public var parametersJsonArray: JSONArray? {
        return getJsonArray(responseJsonObject, ["Parameters"])
    }
    public var responseJsonObject: JSONObject? {
        if let data = self.responseString?.data(using: .utf8) {
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
        return self.status?.isSuccess ?? false
    }

    class func from(mockFilePath: String) -> (ATResponse, Double) {
        let result = ATResponse()
        var delay: Double = 0
        if let fileInputStream = InputStream(fileAtPath: mockFilePath) {
            fileInputStream.open()
            if let mockJson = try? JSONSerialization.jsonObject(with: fileInputStream, options: .allowFragments) as? JSONObject {
                if let headers = getJsonObject(mockJson, ["headers"]) {
                    headers.forEach {
                        result.headers[$0] = $1
                    }
                }
                if let bodyString = getString(mockJson, ["body"]) {
                    result.responseString = bodyString
                } else if let bodyJsonObject = getJsonObject(mockJson, ["body"]), let bodyString = String.init(data: (try? JSONSerialization.data(withJSONObject: bodyJsonObject, options: .prettyPrinted)) ?? Data(), encoding: .utf8) {
                    result.responseString = bodyString
                } else if let bodyJsonArray = getJsonArray(mockJson, ["body"]), let bodyString = String.init(data: (try? JSONSerialization.data(withJSONObject: bodyJsonArray, options: .prettyPrinted)) ?? Data(), encoding: .utf8) {
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

    class func from(responseData: Data?, responseHeaders: URLResponse?, responseError: Error?) -> ATResponse {
        let result = ATResponse()
        let responseHeaders = (responseHeaders as? HTTPURLResponse)
        result.responseCode = responseHeaders?.statusCode ?? -1
        result.headers = responseHeaders?.allHeaderFields ?? [:]
        if result.responseCode / 10 == 20 {
            if let data = responseData, let jsonString = String.init(data: data, encoding: .utf8) {
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

    public class Status {
        public var errorCodeString: String?
        public var description: String?
        
        public class var tokenExpiredCode: String {
            return "G00002"
        }

        public var isSuccess: Bool {
            return self.errorCodeString == kResponseSuccessCode
        }

        class func from(json object: JSONObject?) -> Status? {
            guard let object = object else {
                return nil
            }
            let result = Status()
            result.errorCodeString = getString(object, ["Code"])
            result.description = getString(object, ["Description"])
            return result
        }
    }
}
