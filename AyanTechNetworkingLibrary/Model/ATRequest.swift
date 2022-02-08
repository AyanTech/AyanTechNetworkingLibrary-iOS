//
//  ATRequest.swift
//  InquirySDKLib
//
//  Created by Sepehr Behroozi on 6/25/18.
//  Copyright © 2018 Ayantech. All rights reserved.
//

import Foundation

public typealias BaseResponseHandler = (ATResponse) -> Void
public typealias RefreshTokenCompletionHandler = () -> Void

@objc public protocol ATRequestDelegate: AnyObject {
    @objc optional func atRequestIsTokenValid() -> Bool
    @objc optional func atRequestRefreshToken(completionHandler: @escaping RefreshTokenCompletionHandler)
}

public class ATRequest {
    var id = 0
    var url: String!
    var method: HTTPMethod!
    var headers = ATRequest.defaultHeaders
    var body: Data?
    var task: URLSessionTask?
    var tokenValidationRequired = false
    private var isTokenValid = false
    private var mockFilePath: String?
    public weak var delegate: ATRequestDelegate?

    public var contentType: ContentType = .applicationJson {
        didSet {
            self.headers["Content-Type"] = self.contentType.rawValue
        }
    }

    public enum ContentType: String {
        case applicationJson = "application/json"
        case textPlain = "text/plain"
        case textHtml = "text/html"
    }

    fileprivate class var defaultHeaders: [String: String] {
        return [
            "SDK-Name": "Ayantech-Inquiry-History"
        ]
    }

    public class func request(url: String, method: HTTPMethod = .get) -> ATRequest {
        let result = ATRequest()
        result.url = url
        result.method = method
        result.headers = ATRequest.Configuration.defaultHeaders
        return result
    }

    @discardableResult public func mockResponse(using filePath: String) -> Self {
        self.mockFilePath = filePath
        return self
    }

    @discardableResult public func addHeader(key: String, value: String) -> Self {
        self.headers[key] = value
        return self
    }

    @discardableResult public func setNeedsTokenValidation(_ tokenValidationRequired: Bool) -> Self {
        self.tokenValidationRequired = tokenValidationRequired
        return self
    }

    @discardableResult public func setJsonBody(body: JSONObject, ignoreParameterCreator ignore: Bool = false) -> Self {
        self.body = (ignore ? body : Configuration.parametersCreator(body)).toJsonData()
        self.contentType = .applicationJson
        return self
    }

    @discardableResult public func setStringBody(body: String) -> Self {
        self.body = body.data(using: .utf8)
        self.contentType = .textPlain
        return self
    }

    @discardableResult public func setHtmlBody(body: String) -> Self {
        self.body = body.data(using: .utf8)
        self.contentType = .textHtml
        return self
    }

    public func cancel() {
        self.task?.cancel()
    }

    public func send(responseHandler: BaseResponseHandler?) {
        if tokenValidationRequired && !delegate!.atRequestIsTokenValid!() {
            guard isTokenValid else {
                delegate?.atRequestRefreshToken! { [weak self] in
                    self?.isTokenValid = true
                    self?.send(responseHandler: responseHandler)
                }
                return
            }
        }
        if let mockFile = self.mockFilePath, !mockFile.isEmpty {
            let responseAndDelay = ATResponse.from(mockFilePath: mockFile)
            doWithDelay(responseAndDelay.1) {
                responseHandler?(responseAndDelay.0)
            }
        } else {
            Server.sendRequest(req: self) { (responseData, headers, error) in
                let atResponse = ATResponse.from(responseData: responseData, responseHeaders: headers, responseError: error)
                if atResponse.error?.type == .cancelled {
                    return
                }
                responseHandler?(atResponse)
            }
        }
    }
    
    public func sendSync() -> ATResponse {
        if let mockFile = self.mockFilePath, !mockFile.isEmpty {
            let responseAndDelay = ATResponse.from(mockFilePath: mockFile)
            Utils.sleep(seconds: responseAndDelay.1)
            return responseAndDelay.0
        } else {
            let responseCollection = Server.sendSyncRequest(req: self)
            let atResponse = ATResponse.from(responseData: responseCollection.0, responseHeaders: responseCollection.1, responseError: responseCollection.2)
            return atResponse
        }
    }

    public class Configuration {
        public static var noProxy = true
        public static var timeout: TimeInterval = 30
        public static var defaultHeaders: [String: String] = [:]
        public static var parametersCreator: (JSONObject) -> JSONObject = { input in
            return input
        }
        public static func setLogger(logger: ATNetworkLogging) {
            Server.logger = logger
        }
    }
}
