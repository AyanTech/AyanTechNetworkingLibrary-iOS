//
//  AppNetwork.swift
//  AyantechNetworkingLibraryDemo
//

import AyanTechNetworkingLibrary
import Combine
import Foundation

final class AppNetwork {
    private let token: String
    private let errorMapper: ATErrorMapper
    private let encoder: JSONEncoder
    private let decoder: JSONDecoder

    init(
        token: String,
        errorMapper: ATErrorMapper = ATErrorMapper(),
        encoder: JSONEncoder = JSONEncoder(),
        decoder: JSONDecoder = JSONDecoder()
    ) {
        self.token = token
        self.errorMapper = errorMapper
        self.encoder = encoder
        self.decoder = decoder
    }

    func post<Input: Encodable, Output: Decodable>(
        url: String,
        parameters: Input
    ) -> AnyPublisher<Output, ATError> {
        let body: JSONObject
        do {
            body = try makeRequestBody(parameters: parameters)
        } catch {
            return Fail<Output, ATError>(
                error: errorMapper.toATError(error)
            )
            .eraseToAnyPublisher()
        }

        return ATRequest.request(url: url, method: .post)
            .setJsonBody(
                body: body,
                ignoreParameterCreator: true
            )
            .valuePublisher()
            .tryMap { response in
                guard let parameters = response.parametersJsonObject,
                      JSONSerialization.isValidJSONObject(parameters)
                else {
                    throw URLError(.cannotParseResponse)
                }

                let data = try JSONSerialization.data(withJSONObject: parameters)
                return try self.decoder.decode(Output.self, from: data)
            }
            .mapError { self.errorMapper.toATError($0) }
            .eraseToAnyPublisher()
    }

    private func makeRequestBody<Input: Encodable>(parameters: Input) throws -> JSONObject {
        let data = try encoder.encode(parameters)
        let json = try JSONSerialization.jsonObject(with: data)
        guard let parametersObject = json as? JSONObject else {
            throw EncodingError.invalidValue(
                parameters,
                EncodingError.Context(
                    codingPath: [],
                    debugDescription: "Parameters must encode to a JSON object"
                )
            )
        }

        return [
            "Identity": [
                "Token": token,
            ],
            "Parameters": parametersObject,
        ]
    }
}
