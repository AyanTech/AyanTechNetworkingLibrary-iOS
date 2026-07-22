//
//  DonationReferrerTypesRemoteDataSource.swift
//  AyantechNetworkingLibraryDemo
//

import AyanTechNetworkingLibrary
import Combine

final class DonationReferrerTypesRemoteDataSource {
    private let appNetwork: AppNetwork
    private let url: String

    init(appNetwork: AppNetwork, url: String) {
        self.appNetwork = appNetwork
        self.url = url
    }

    func getReferrerTypes(input: DonationReferrerTypesRequestDTO) -> AnyPublisher<DonationReferrerTypesDTO, ATError> {
        appNetwork.post(
            url: url,
            parameters: input
        )
    }
}
