//
//  ATRequest.swift
//  InquirySDKLib
//
//  Created by Sepehr Behroozi on 6/25/18.
//  Copyright © 2018 Ayantech. All rights reserved.
//

import Foundation
import Alamofire

public typealias BaseResponseHandler = (ATResponse) -> Void

public class ATRequest {
    var url: String!
    var method: HTTPMethod!
    var headers = ATRequest.defaultHeaders
    var body: Parameters?
    var encoding: ParameterEncoding = JSONEncoding.default
    
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
        self.body = body
        self.contentType = .applicationJson
        self.encoding = JSONEncoding.default
        return self
    }

    @discardableResult public func setStringBody(body: String) -> Self {
        self.body = JSONObject()
        self.encoding = body
        self.contentType = .textPlain
        return self
    }

    @discardableResult public func setHtmlBody(body: String) -> Self {
        self.body = JSONObject()
        self.encoding = body
        self.contentType = .textHtml
        return self
    }
    
    public func cancel() {
        Alamofire.SessionManager.default.session.getTasksWithCompletionHandler { (sessionTasks, uploadTasks, downloadTasks) in
            sessionTasks.forEach {
                if $0.originalRequest?.url?.absoluteString == self.url {
                    $0.cancel()
                }
            }
            uploadTasks.forEach {
                if $0.originalRequest?.url?.absoluteString == self.url {
                    $0.cancel()
                }
            }
            downloadTasks.forEach {
                if $0.originalRequest?.url?.absoluteString == self.url {
                    $0.cancel()
                }
            }
        }
    }
    
    public func send(responseHandler: BaseResponseHandler?) {
        Server.sendRequest(req: self) { (response) in
            let atResponse = ATResponse.from(response: response)
            if atResponse.error?.type == .cancelled {
                return
            }
            responseHandler?(atResponse)
        }
    }
}
