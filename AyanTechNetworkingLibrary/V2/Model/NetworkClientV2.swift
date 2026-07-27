//
//  NetworkClientV2.swift
//  AyanTechNetworkingLibrary
//

import Combine
import Foundation

public enum NetworkClientV2 {
    nonisolated(unsafe) public static var logger: ATNetworkLogging = DefaultATNetworkLogger()

    static let urlSession: URLSession = buildDefaultSession()

    public static func buildDefaultSession() -> URLSession {
        URLSession(configuration: .default)
    }

    public static func setLogger(_ logger: ATNetworkLogging) {
        self.logger = logger
    }

    public static func setLoggerLevel(_ level: ATLoggerLevel) {
        switch level {
        case .default:
            logger = DefaultATNetworkLogger()
        case .none:
            logger = SilentATNetworkLogger()
        }
    }

    static func publisher<Parameters: Encodable & Sendable, Response: Decodable & Sendable>(
        for request: ATRequestV2<Parameters>,
        _ type: Response.Type
    ) -> AnyPublisher<ATResponseV2<Response>, ATErrorV2> {
        guard let urlRequest = URLRequestBuilder.build(from: request) else {
            logRequest(request, body: nil)
            logResponse(for: request, requestBody: nil, data: nil, response: nil)
            return Fail(error: ATErrorV2(errorType: .invalidRequest))
                .eraseToAnyPublisher()
        }

        logRequest(request, body: urlRequest.httpBody)

        return urlSession.dataTaskPublisher(for: urlRequest)
            .handleEvents(
                receiveOutput: { output in
                    logResponse(for: request, requestBody: urlRequest.httpBody, data: output.data, response: output.response)
                },
                receiveCompletion: { completion in
                    if case .failure = completion {
                        logResponse(for: request, requestBody: urlRequest.httpBody, data: nil, response: nil)
                    }
                }
            )
            .tryMap { output in
                try ATResponseV2<Response>.decode(data: output.data, response: output.response)
            }
            .mapError(ATErrorV2.from)
            .eraseToAnyPublisher()
    }

    private static func logRequest<Parameters: Encodable & Sendable>(
        _ request: ATRequestV2<Parameters>,
        body: Data?
    ) {
        logger.logRequest(
            url: request.url,
            method: .post,
            headers: request.headers,
            body: body
        )
    }

    private static func logResponse<Parameters: Encodable & Sendable>(
        for request: ATRequestV2<Parameters>,
        requestBody: Data?,
        data: Data?,
        response: URLResponse?
    ) {
        let responseCode = (response as? HTTPURLResponse)?.statusCode ?? -1
        let responseHeaders = ((response as? HTTPURLResponse)?.allHeaderFields as? [String: String]) ?? [:]
        logger.logResponse(
            requestUrl: request.url,
            requestMethod: .post,
            requestHeaders: request.headers,
            requestBody: requestBody,
            responseCode: responseCode,
            responseHeaders: responseHeaders,
            responseBody: data
        )
    }
}
