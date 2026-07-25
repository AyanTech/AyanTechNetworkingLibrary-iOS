//
//  ATResponse+Decodable.swift
//  AyanTechNetworkingLibrary
//

import Foundation

public extension ATResponse {
    func decodeParameters<T: Decodable>(
        as type: T.Type = T.self,
        decoder: JSONDecoder = JSONDecoder()
    ) throws -> T {
        guard let parameters = parametersJsonObject,
              JSONSerialization.isValidJSONObject(parameters)
        else {
            throw ATError.decodingError
        }

        do {
            let data = try JSONSerialization.data(withJSONObject: parameters)
            return try decoder.decode(type, from: data)
        } catch {
            throw ATError.decodingError
        }
    }
}
