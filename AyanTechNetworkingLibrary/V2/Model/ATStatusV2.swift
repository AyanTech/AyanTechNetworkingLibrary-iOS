import Foundation

public struct ATStatusV2: Decodable, Sendable {
    public static let successCode = "G00000"
    public static let tokenExpiredCode = "G00002"

    public let code: String?
    public let message: String?
    public let type: String?
    public let isFromCache: Bool?
    public let retryable: Bool?

    public init(
        code: String? = nil,
        message: String? = nil,
        type: String? = nil,
        isFromCache: Bool? = nil,
        retryable: Bool? = nil
    ) {
        self.code = code
        self.message = message
        self.type = type
        self.isFromCache = isFromCache
        self.retryable = retryable
    }

    public var isSuccess: Bool {
        code == Self.successCode
    }

    public var isTokenExpired: Bool {
        code == Self.tokenExpiredCode
    }

    private enum CodingKeys: String, CodingKey {
        case code = "Code"
        case message = "Description"
        case type = "Type"
        case isFromCache = "IsFromCache"
        case retryable = "Retryable"
    }
}
