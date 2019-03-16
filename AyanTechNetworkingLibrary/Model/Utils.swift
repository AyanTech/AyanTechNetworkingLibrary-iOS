//
//  Utils.swift
//  InquirySDKLib
//
//  Created by Sepehr Behroozi on 6/24/18.
//  Copyright © 2018 Ayantech. All rights reserved.
//

import UIKit


class Utils {
    class func runOnMainThread(_ code: @escaping () -> Void) {
        if Thread.isMainThread {
            code()
        } else {
            DispatchQueue.main.async {
                code()
            }
        }
    }
    
    class func sleep(seconds: TimeInterval) {
        Thread.sleep(forTimeInterval: seconds)
    }
}

func doWithDelay(_ delay: Double, closure:@escaping () -> Void) {
    DispatchQueue.main.asyncAfter(
        deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
}

public typealias JSONObject = [String: Any]
public typealias JSONArray = [Any]
let onePx = 1 / UIScreen.main.scale

// ===========================================
//   start of Helper functions of parsing json
// ===========================================

func getValue<T>(input: Any?, subscripts: [Any], endType: T) -> T? {
    
    var extractingValue = input
    
    subscripts.forEach { (key) in
        if let intKey = key as? Int {
            extractingValue = (extractingValue as? [Any])?[intKey]
        }
        if let stringKey = key as? String {
            extractingValue = (extractingValue as? [String: Any])?[stringKey]
        }
    }
    switch endType {
    case is Int :
        let result = extractingValue as? Int ?? (extractingValue as? String)?.toInt()
        return result as? T
    case is Double:
        let result = extractingValue as? Double ?? (extractingValue as? String)?.toDouble()
        return result as? T
    case is String:
        let result = extractingValue as? String ?? (extractingValue as? Int)?.toString() ?? (extractingValue as? Double)?.toString()
        if result == "null" {
            return nil
        } else {
            return result as? T
        }
    case is Bool:
        var result = extractingValue as? Bool ?? (extractingValue as? String)?.toBool()
        if result == nil {
            if let resultInt = extractingValue as? Int {
                result = resultInt == 1
            }
        }
        return result as? T
    default:
        return extractingValue as? T
    }
}

func getInt(_ input: Any?, _ subscripts: [Any]) -> Int? {
    return getValue(input: input, subscripts: subscripts, endType: Int())
}

func getDouble(_ input: Any?, _ subscripts: [Any]) -> Double? {
    return getValue(input: input, subscripts: subscripts, endType: Double())
}

func getString(_ input: Any?, _ subscripts: [Any]) -> String? {
    return getValue(input: input, subscripts: subscripts, endType: String())
}

func getBool(_ input: Any?, _ subscripts: [Any]) -> Bool? {
    return getValue(input: input, subscripts: subscripts, endType: Bool())
}

func getJsonArray(_ input: Any?, _ subscripts: [Any]) -> JSONArray? {
    return getValue(input: input, subscripts: subscripts, endType: JSONArray())
}

func getJsonObject(_ input: Any?, _ subscripts: [Any]) -> JSONObject? {
    return getValue(input: input, subscripts: subscripts, endType: JSONObject())
}

// ===========================================
//   end of Helper functions of parsing json
// ===========================================
