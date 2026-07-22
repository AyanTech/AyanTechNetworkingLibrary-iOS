//
//  DonationReferrerTypesRemoteDataSource.swift
//  AyantechNetworkingLibraryDemo
//

import AyanTechNetworkingLibrary
import Combine

protocol DonationReferrerTypesRemoteDataSourceProtocol {
    func getReferrerTypes(input: DonationReferrerTypesRequestDTO) -> AnyPublisher<DonationReferrerTypesDTO, ATError>
}

final class DonationReferrerTypesRemoteDataSource: DonationReferrerTypesRemoteDataSourceProtocol {
    private let appNetwork: AppNetwork

    init(appNetwork: AppNetwork) {
        self.appNetwork = appNetwork
    }

    func getReferrerTypes(input: DonationReferrerTypesRequestDTO) -> AnyPublisher<DonationReferrerTypesDTO, ATError> {
        appNetwork.post(
            url: DonationReferrerTypesAPI.getReferrerTypesURL,
            parameters: input
        )
    }
}
