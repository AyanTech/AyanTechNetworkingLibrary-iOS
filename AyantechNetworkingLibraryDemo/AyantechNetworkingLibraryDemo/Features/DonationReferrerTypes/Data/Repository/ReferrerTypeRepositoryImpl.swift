//
//  ReferrerTypeRepositoryImpl.swift
//  AyantechNetworkingLibraryDemo
//

import AyanTechNetworkingLibrary
import Combine

final class ReferrerTypeRepositoryImpl: ReferrerTypeRepository {
    private let remoteDataSource: DonationReferrerTypesRemoteDataSource
    private let mapper: DonationReferrerTypesMapper

    init(
        remoteDataSource: DonationReferrerTypesRemoteDataSource,
        mapper: DonationReferrerTypesMapper
    ) {
        self.remoteDataSource = remoteDataSource
        self.mapper = mapper
    }

    func getReferrerTypes() -> AnyPublisher<[ReferrerType], ATError> {
        remoteDataSource.getReferrerTypes(
            input: DonationReferrerTypesRequestDTO()
        )
            .map(mapper.toDomain)
            .eraseToAnyPublisher()
    }
}
