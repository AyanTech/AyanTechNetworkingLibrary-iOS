//
//  ATRequest+Combine.swift
//  AyanTechNetworkingLibrary
//

import Combine
import Foundation

public extension ATRequest {
    /// Always emits `ATResponse`. Inspect `response.error` for failures.
    /// Cancelling the subscription cancels the underlying URL session task.
    func responsePublisher() -> AnyPublisher<ATResponse, Never> {
        Deferred {
            if let mockFile = self.mockFilePath, !mockFile.isEmpty {
                let responseAndDelay = ATResponse.from(mockFilePath: mockFile)
                return Just(responseAndDelay.0)
                    .delay(
                        for: .seconds(max(0, responseAndDelay.1)),
                        scheduler: DispatchQueue.main
                    )
                    .eraseToAnyPublisher()
            }

            NetworkClient.logRequest(self)
            let request = URLRequestBuilder.build(from: self)

            return NetworkClient.defaultUrlSession.dataTaskPublisher(for: request)
                .map { data, response in
                    NetworkClient.logResponse(for: self, data: data, response: response)
                    return ATResponse.from(
                        responseData: data,
                        responseHeaders: response,
                        responseError: nil
                    )
                }
                .catch { error in
                    NetworkClient.logResponse(for: self, data: nil, response: nil)
                    return Just(
                        ATResponse.from(
                            responseData: nil,
                            responseHeaders: nil,
                            responseError: error
                        )
                    )
                }
                .eraseToAnyPublisher()
        }
        .eraseToAnyPublisher()
    }

    /// Emits only on success. Network and API errors are delivered as `Failure`.
    func valuePublisher() -> AnyPublisher<ATResponse, ATError> {
        responsePublisher()
            .tryMap { response in
                if let error = response.error {
                    throw error
                }
                return response
            }
            .mapError { error in
                (error as? ATError) ?? .generalError
            }
            .eraseToAnyPublisher()
    }

    /// Emits a decoded `Parameters` value on success. Network, API, and decoding errors are delivered as `Failure`.
    func valuePublisher<T: Decodable>(
        as type: T.Type = T.self,
        decoder: JSONDecoder = JSONDecoder()
    ) -> AnyPublisher<T, ATError> {
        valuePublisher()
            .tryMap { try $0.decodeParameters(as: type, decoder: decoder) }
            .mapError { error in
                (error as? ATError) ?? .generalError
            }
            .eraseToAnyPublisher()
    }
}
