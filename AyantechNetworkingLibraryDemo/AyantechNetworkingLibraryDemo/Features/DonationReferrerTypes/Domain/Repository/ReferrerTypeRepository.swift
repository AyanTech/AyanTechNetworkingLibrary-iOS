//
//  ReferrerTypeRepository.swift
//  AyantechNetworkingLibraryDemo
//

import AyanTechNetworkingLibrary
import Combine

protocol ReferrerTypeRepository {
    func getReferrerTypes() -> AnyPublisher<[ReferrerType], ATErrorV2>
}
