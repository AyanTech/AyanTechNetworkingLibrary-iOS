//
//  URLSessionBuilder.swift
//  AyanTechNetworkingLibrary
//

import Foundation

enum URLSessionBuilder {
    static func makeDefaultSession() -> URLSession {
        let config = URLSessionConfiguration.default
        if ATRequest.Configuration.noProxy {
            config.connectionProxyDictionary = [:]
        }
        return URLSession(configuration: config)
    }
}
