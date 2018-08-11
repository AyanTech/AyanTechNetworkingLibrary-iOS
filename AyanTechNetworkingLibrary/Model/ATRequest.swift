//
//  ATRequest.swift
//  InquirySDKLib
//
//  Created by Sepehr Behroozi on 6/25/18.
//  Copyright © 2018 Ayantech. All rights reserved.
//

import Foundation

public typealias BaseResponseHandler = (ATResponse) -> Void

public class ATRequest {
    var id = 0
    var url: String!
    var method: HTTPMethod!
    var headers = ATRequest.defaultHeaders
    var body: Data?
    var task: URLSessionTask?
    
    var contentType: ContentType = .applicationJson {
        didSet {
            self.headers["Content-Type"] = self.contentType.rawValue
        }
    }

    enum ContentType: String {
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
        return result
    }

    @discardableResult public func addHeader(key: String, value: String) -> Self {
        self.headers[key] = value
        return self
    }

    @discardableResult public func setJsonBody(body: JSONObject) -> Self {
        self.body = body.toJsonData()
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
        Server.sendRequest(req: self) { (responseData, headers, error) in
            let atResponse = ATResponse.from(responseData: responseData, responseHeaders: headers, responseError: error)
            if atResponse.error?.type == .cancelled {
                return
            }
            responseHandler?(atResponse)
        }
    }
}
