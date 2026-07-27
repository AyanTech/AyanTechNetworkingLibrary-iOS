//
//  AppNetwork.swift
//  AyantechNetworkingLibraryDemo
//

import AyanTechNetworkingLibrary
import Combine

final class AppNetwork {
    private let configuration: ConfigurationV2

    init(token: String) {
        configuration = ConfigurationV2(token: token)
    }

    func post<Input: Encodable & Sendable, Output: Decodable & Sendable>(
        url: String,
        parameters: Input
    ) -> AnyPublisher<Output, ATErrorV2> {
        ATRequestV2(
            url: url,
            parameters: parameters,
            configuration: configuration
        )
        .valuePublisher(as: Output.self)
    }
}
