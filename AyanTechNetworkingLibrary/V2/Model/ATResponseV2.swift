import Foundation

public struct ATResponseV2<Value: Sendable>: Sendable {
    public let value: Value
    public let body: Data
    public let httpStatusCode: Int
    public let headers: [String: String]
    public let status: ATStatusV2

    init(
        value: Value,
        body: Data,
        httpStatusCode: Int,
        headers: [String: String],
        status: ATStatusV2
    ) {
        self.value = value
        self.body = body
        self.httpStatusCode = httpStatusCode
        self.headers = headers
        self.status = status
    }

    public var responseString: String? {
        String(data: body, encoding: .utf8)
    }

    static func decode(
        data: Data?,
        response: URLResponse,
        decoder: JSONDecoder = JSONDecoder()
    ) throws -> ATResponseV2<Value> where Value: Decodable {
        guard let httpResponse = response as? HTTPURLResponse else {
            throw ATErrorV2(errorType: .general)
        }

        let body = data ?? Data()
        let httpStatusCode = httpResponse.statusCode
        let headers = normalizedHeaders(from: httpResponse)
        let serverResponse = try? decoder.decode(ATServerResponse<Value>.self, from: body)

        guard httpStatusCode == 200 else {
            throw ATErrorV2(errorType: .httpError, status: serverResponse?.status, httpStatusCode: httpStatusCode)
        }

        guard let serverResponse else {
            throw ATErrorV2(errorType: .serialization, httpStatusCode: httpStatusCode)
        }

        guard let status = serverResponse.status else {
            throw ATErrorV2(errorType: .general, httpStatusCode: httpStatusCode)
        }

        guard status.isSuccess else {
            throw ATErrorV2(errorType: .api, status: status, httpStatusCode: httpStatusCode)
        }

        guard let value = serverResponse.parameters else {
            throw ATErrorV2(errorType: .serialization, status: status, httpStatusCode: httpStatusCode)
        }

        return ATResponseV2(
            value: value,
            body: body,
            httpStatusCode: httpStatusCode,
            headers: headers,
            status: status
        )
    }

    private static func normalizedHeaders(from response: HTTPURLResponse) -> [String: String] {
        var headers: [String: String] = [:]
        response.allHeaderFields.forEach { key, value in
            headers[String(describing: key)] = String(describing: value)
        }
        return headers
    }
}
