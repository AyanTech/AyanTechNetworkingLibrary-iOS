//
//  DonationReferrerTypesRemoteDataSource.swift
//  AyantechNetworkingLibraryDemo
//

import AyanTechNetworkingLibrary
import Combine

protocol DonationReferrerTypesRemoteDataSourceProtocol {
    func getReferrerTypes(input: DonationReferrerTypesRequestDTO) -> AnyPublisher<DonationReferrerTypesDTO, ATErrorV2>
}

final class DonationReferrerTypesRemoteDataSource: DonationReferrerTypesRemoteDataSourceProtocol {
    private let appNetwork: AppNetwork

    init(appNetwork: AppNetwork) {
        self.appNetwork = appNetwork
    }

    func getReferrerTypes(input: DonationReferrerTypesRequestDTO) -> AnyPublisher<DonationReferrerTypesDTO, ATErrorV2> {
        appNetwork.post(
            url: DonationReferrerTypesAPI.getReferrerTypesURL,
            parameters: input
        )
    }
}
