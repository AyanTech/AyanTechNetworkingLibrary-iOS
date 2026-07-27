//
//  GetReferrerTypesUseCase.swift
//  AyantechNetworkingLibraryDemo
//

import AyanTechNetworkingLibrary
import Combine

protocol GetReferrerTypesUseCaseProtocol {
    func execute() -> AnyPublisher<[ReferrerType], ATErrorV2>
}

struct GetReferrerTypesUseCase: GetReferrerTypesUseCaseProtocol {
    private let repository: ReferrerTypeRepository
    private let sorter: ReferrerTypeSorter

    init(
        repository: ReferrerTypeRepository,
        sorter: ReferrerTypeSorter
    ) {
        self.repository = repository
        self.sorter = sorter
    }

    func execute() -> AnyPublisher<[ReferrerType], ATErrorV2> {
        repository.getReferrerTypes()
            .map(sorter.sortByName)
            .eraseToAnyPublisher()
    }
}
