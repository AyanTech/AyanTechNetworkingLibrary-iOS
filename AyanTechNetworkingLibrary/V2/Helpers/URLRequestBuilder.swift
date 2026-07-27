//
//  URLRequestBuilder.swift
//  AyanTechNetworkingLibrary
//

import Foundation

enum URLRequestBuilder {
    static func build<Parameters: Encodable & Sendable>(from request: ATRequestV2<Parameters>) -> URLRequest? {
        guard let requestURL = URL(string: request.url) else {
            return nil
        }

        let envelope = RequestEnvelope(
            identity: .init(token: request.configuration.token),
            parameters: request.parameters
        )

        guard let body = try? JSONEncoder().encode(envelope) else {
            return nil
        }

        var urlRequest = URLRequest(
            url: requestURL,
            cachePolicy: .reloadIgnoringLocalCacheData,
            timeoutInterval: request.configuration.timeout
        )
        urlRequest.httpMethod = "POST"
        urlRequest.httpBody = body

        request.headers.forEach {
            urlRequest.setValue($0.value, forHTTPHeaderField: $0.key)
        }

        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")

        return urlRequest
    }
}

private struct RequestEnvelope<Parameters: Encodable>: Encodable {
    let identity: Identity
    let parameters: Parameters?

    struct Identity: Encodable {
        let token: String?

        private enum CodingKeys: String, CodingKey {
            case token = "Token"
        }
    }

    private enum CodingKeys: String, CodingKey {
        case identity = "Identity"
        case parameters = "Parameters"
    }
}
