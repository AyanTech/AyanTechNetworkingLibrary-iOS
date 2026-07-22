//
//  GetReferrerTypesUseCase.swift
//  AyantechNetworkingLibraryDemo
//

import AyanTechNetworkingLibrary
import Combine

struct GetReferrerTypesUseCase {
    private let repository: ReferrerTypeRepository
    private let sorter: ReferrerTypeSorter

    init(
        repository: ReferrerTypeRepository,
        sorter: ReferrerTypeSorter
    ) {
        self.repository = repository
        self.sorter = sorter
    }

    func execute() -> AnyPublisher<[ReferrerType], ATError> {
        repository.getReferrerTypes()
            .map(sorter.sortByName)
            .eraseToAnyPublisher()
    }
}
