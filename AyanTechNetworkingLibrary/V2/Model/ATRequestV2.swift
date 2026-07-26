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
    func responsePublisher<Response: Decodable & Sendable>(as type: Response.Type = Response.self) -> AnyPublisher<ATResponseV2<Response>, ATErrorV2> {
        NetworkClientV2.publisher(for: self, as: type)
    }

    func valuePublisher<Response: Decodable & Sendable>(as type: Response.Type = Response.self) -> AnyPublisher<Response, ATErrorV2> {
        responsePublisher(as: type)
            .map(\.value)
            .eraseToAnyPublisher()
    }
}
