//
//  URLRequestBuilder.swift
//  AyanTechNetworkingLibrary
//

import Foundation

enum URLRequestBuilder {
    static func make(from req: ATRequest) -> URLRequest {
        var request = URLRequest(
            url: URL(string: req.url)!,
            cachePolicy: .reloadIgnoringLocalCacheData,
            timeoutInterval: ATRequest.Configuration.timeout
        )
        request.httpMethod = req.method.rawValue
        req.headers.forEach { request.addValue($0.value, forHTTPHeaderField: $0.key) }
        request.httpBody = req.body
        return request
    }
}
