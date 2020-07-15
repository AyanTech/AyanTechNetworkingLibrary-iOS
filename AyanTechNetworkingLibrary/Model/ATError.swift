//
//  ATError.swift
//  InquirySDKLib
//
//  Created by Sepehr Behroozi on 6/24/18.
//  Copyright © 2018 Ayantech. All rights reserved.
//

import Foundation

public class ATError: NSObject {
    public var persianDescription: String?
    public var code: Int?
    public var type: ATErrorType?
    public var name: String!
    
    public class var generalError: ATError {
        let result = ATError()
        result.code = -1
        result.type = .general
        return result
    }
    
    class func from(error: Error?) -> ATError {
        let result = ATError.generalError
        if let error = error as? URLError {
            result.code = error.errorCode
            result.type = ATErrorType.from(error: error)
            result.name = error.code.name
            result.persianDescription = result.type?.persianDescription ?? PersianStrings.generalNetworkError.rawValue
        }
        return result
    }
    
    class func from(status: ATResponse.Status?) -> ATError? {
        if status == nil || status?.errorCodeString == kResponseSuccessCode {
            return nil
        } else {
            let result = ATError.generalError
            result.code = -1
            result.persianDescription = status?.description ?? result.persianDescription
            result.name = ""
            return result
        }
    }
}

@objc public enum ATErrorType: Int {
    case noInternet
    case timeout
    case serverError
    case general
    case cancelled
    
    var persianDescription: String {
        switch self {
        case .noInternet:
            return PersianStrings.noInternetConnection.rawValue
        case .timeout:
            return PersianStrings.timeoutError.rawValue
        case .serverError:
            return PersianStrings.internalServerError.rawValue
        case .general:
            return PersianStrings.generalNetworkError.rawValue
        case .cancelled:
            return ""
        }
    }
    
    static func from(error: URLError) -> ATErrorType {
        switch error.code {
        case .notConnectedToInternet:
            return .noInternet
        case URLError.Code.timedOut:
            return .timeout
        case URLError.Code.badServerResponse:
            return .serverError
        case URLError.Code.cancelled:
            return .cancelled
        default:
            return .general
        }
    }
}
