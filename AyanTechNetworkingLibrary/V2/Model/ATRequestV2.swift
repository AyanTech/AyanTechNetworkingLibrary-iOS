import Combine
import Foundation

public struct ATRequestV2<Parameters: Encodable & Sendable>: Sendable {
    public let url: String
    public let parameters: Parameters?
    public let headers: [String: String]
    public let configuration: ConfigurationV2

    public init(
        url: String,
        parameters: Parameters?,
        headers: [String: String] = [:],
        configuration: ConfigurationV2 = .init()
    ) {
        self.url = url
        self.parameters = parameters
        self.configuration = configuration
        self.headers = configuration.defaultHeaders.merging(headers) { _, requestValue in requestValue }
    }
}

public struct ConfigurationV2: Sendable {
    public let timeout: TimeInterval
    public let defaultHeaders: [String: String]
    public let token: String?

    public init(
        timeout: TimeInterval = 30,
        defaultHeaders: [String: String] = [:],
        token: String? = nil
    ) {
        self.timeout = timeout
        self.defaultHeaders = defaultHeaders
        self.token = token
    }
}

public extension ATRequestV2 {
    func responsePublisher<Response: Decodable & Sendable>(_ type: Response.Type) -> AnyPublisher<ATResponseV2<Response>, ATErrorV2> {
        NetworkClientV2.publisher(for: self, type)
    }

    func valuePublisher<Response: Decodable & Sendable>(_ type: Response.Type) -> AnyPublisher<Response, ATErrorV2> {
        responsePublisher(type)
            .flatMap { response -> AnyPublisher<Response, ATErrorV2> in
                guard let value = response.value else {
                    return Fail(
                        error: ATErrorV2(errorType: .serialization)
                    )
                    .eraseToAnyPublisher()
                }

                return Just(value)
                    .setFailureType(to: ATErrorV2.self)
                    .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
    
    func safeValuePublisher<Response: Decodable & Sendable>(_ type: Response.Type) -> AnyPublisher<Response?, ATErrorV2> {
        responsePublisher(type)
            .map(\.value)
            .eraseToAnyPublisher()
    }
}
