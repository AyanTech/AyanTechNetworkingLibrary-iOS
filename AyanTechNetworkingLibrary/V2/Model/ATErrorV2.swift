import Foundation

public enum ATErrorTypeV2: Sendable {
    case noInternet
    case timeout
    case cancelled
    case invalidRequest
    case general
    case httpError
    case serialization
    case api

    static func from(error: URLError) -> ATErrorTypeV2 {
        switch error.code {
        case .notConnectedToInternet:
            return .noInternet
        case .timedOut:
            return .timeout
        case .cancelled:
            return .cancelled
        default:
            return .general
        }
    }
}

public struct ATErrorV2: Error, Sendable {
    public let errorType: ATErrorTypeV2
    public let status: ATStatusV2?
    public let httpStatusCode: Int?

    public init(
        errorType: ATErrorTypeV2,
        status: ATStatusV2? = nil,
        httpStatusCode: Int? = nil
    ) {
        self.errorType = errorType
        self.status = status
        self.httpStatusCode = httpStatusCode
    }

    public var message: String {
        switch errorType {
        case .noInternet:
            return PersianStringsV2.noInternetConnection.rawValue
        case .timeout:
            return PersianStringsV2.timeoutError.rawValue
        case .cancelled:
            return ""
        case .invalidRequest:
            return PersianStringsV2.generalNetworkError.rawValue
        case .general:
            return PersianStringsV2.generalNetworkError.rawValue
        case .httpError:
            return PersianStringsV2.not200.rawValue
        case .serialization:
            return PersianStringsV2.serializationError.rawValue
        case .api:
            if let message = status?.message, !message.isEmpty {
                return message
            }
            if isTokenExpired {
                return PersianStringsV2.loginRequired.rawValue
            }
            return PersianStringsV2.generalNetworkError.rawValue
        }
    }

    public var isTokenExpired: Bool {
        status?.isTokenExpired ?? false
    }

    public static func from(_ error: Error) -> ATErrorV2 {
        if let error = error as? ATErrorV2 {
            return error
        }
        if let urlError = error as? URLError {
            return ATErrorV2(errorType: .from(error: urlError))
        }
        return ATErrorV2(errorType: .general)
    }
}
