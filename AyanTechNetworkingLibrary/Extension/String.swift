//
//  String.swift
//  InquirySDKLib
//
//  Created by Sepehr Behroozi on 6/24/18.
//  Copyright © 2018 Ayantech. All rights reserved.
//

import Foundation
import Alamofire

extension String: ParameterEncoding {
    public func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
        var req = try urlRequest.asURLRequest()
        req.httpBody = self.data(using: .utf8, allowLossyConversion: false)
        return req
    }
    
    func toInt() -> Int? {
        return Int(self)
    }
    
    func toDouble() -> Double? {
        return Double(self)
    }
    
    func toBool() -> Bool? {
        switch self.lowercased() {
        case "true":
            return true
        case "false":
            return false
        default:
            return nil
        }
    }
    
    func toEnNumbers() -> String {
        var str: String = self.replacingOccurrences(of: "۰", with: "0", options: .literal, range: nil)
        str = str.replacingOccurrences(of: "۱", with: "1", options: .literal, range: nil)
        str = str.replacingOccurrences(of: "۲", with: "2", options: .literal, range: nil)
        str = str.replacingOccurrences(of: "۳", with: "3", options: .literal, range: nil)
        str = str.replacingOccurrences(of: "۴", with: "4", options: .literal, range: nil)
        str = str.replacingOccurrences(of: "۵", with: "5", options: .literal, range: nil)
        str = str.replacingOccurrences(of: "۶", with: "6", options: .literal, range: nil)
        str = str.replacingOccurrences(of: "۷", with: "7", options: .literal, range: nil)
        str = str.replacingOccurrences(of: "۸", with: "8", options: .literal, range: nil)
        str = str.replacingOccurrences(of: "۹", with: "9", options: .literal, range: nil)
        str = str.replacingOccurrences(of: "٤", with: "4", options: .literal, range: nil)
        str = str.replacingOccurrences(of: "٥", with: "5", options: .literal, range: nil)
        str = str.replacingOccurrences(of: "٦", with: "6", options: .literal, range: nil)
        return str
    }
    
    func toFaNumbers() -> String {
        var str: String = self.replacingOccurrences(of: "0", with: "۰", options: .literal, range: nil)
        str = str.replacingOccurrences(of: "1", with: "۱", options: .literal, range: nil)
        str = str.replacingOccurrences(of: "2", with: "۲", options: .literal, range: nil)
        str = str.replacingOccurrences(of: "3", with: "۳", options: .literal, range: nil)
        str = str.replacingOccurrences(of: "4", with: "۴", options: .literal, range: nil)
        str = str.replacingOccurrences(of: "5", with: "۵", options: .literal, range: nil)
        str = str.replacingOccurrences(of: "6", with: "۶", options: .literal, range: nil)
        str = str.replacingOccurrences(of: "7", with: "۷", options: .literal, range: nil)
        str = str.replacingOccurrences(of: "8", with: "۸", options: .literal, range: nil)
        str = str.replacingOccurrences(of: "9", with: "۹", options: .literal, range: nil)
        return str
    }
}
