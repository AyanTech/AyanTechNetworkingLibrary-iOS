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
    
    class func from(responseData: Data?, responseHeaders: URLResponse?, responseError: Error?) -> ATResponse {
        let result = ATResponse()
        result.responseCode = (responseHeaders as? HTTPURLResponse)?.statusCode ?? -1
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
        return result
    }
    
    public class Status {
        public var errorCodeString: String?
        public var description: String?

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
