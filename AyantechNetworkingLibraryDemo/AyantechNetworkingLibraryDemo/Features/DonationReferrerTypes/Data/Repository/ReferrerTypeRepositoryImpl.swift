//
//  ReferrerTypeRepositoryImpl.swift
//  AyantechNetworkingLibraryDemo
//

import AyanTechNetworkingLibrary
import Combine

final class ReferrerTypeRepositoryImpl: ReferrerTypeRepository {
    private let remoteDataSource: DonationReferrerTypesRemoteDataSourceProtocol
    private let mapper: DonationReferrerTypesMapper

    init(
        remoteDataSource: DonationReferrerTypesRemoteDataSourceProtocol,
        mapper: DonationReferrerTypesMapper
    ) {
        self.remoteDataSource = remoteDataSource
        self.mapper = mapper
    }

    func getReferrerTypes() -> AnyPublisher<[ReferrerType], ATErrorV2> {
        remoteDataSource.getReferrerTypes(
            input: DonationReferrerTypesRequestDTO()
        )
            .map(mapper.toDomain)
            .eraseToAnyPublisher()
    }
}
