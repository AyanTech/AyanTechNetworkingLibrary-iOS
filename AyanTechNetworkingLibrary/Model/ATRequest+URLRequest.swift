//
//  ATRequest+URLRequest.swift
//  AyanTechNetworkingLibrary
//

import Foundation

extension ATRequest {
    func buildURLRequest() -> URLRequest {
        var request = URLRequest(
            url: URL(string: url)!,
            cachePolicy: .reloadIgnoringLocalCacheData,
            timeoutInterval: ATRequest.Configuration.timeout
        )
        request.httpMethod = method.rawValue
        headers.forEach { request.addValue($0.value, forHTTPHeaderField: $0.key) }
        request.httpBody = body
        return request
    }
}
