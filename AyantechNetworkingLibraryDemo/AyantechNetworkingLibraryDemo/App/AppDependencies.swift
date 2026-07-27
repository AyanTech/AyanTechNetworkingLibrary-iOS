//
//  AppDependencies.swift
//  AyantechNetworkingLibraryDemo
//

import UIKit

@MainActor
final class AppDependencies {
    private let appNetwork: AppNetwork

    init() {
        appNetwork = AppNetwork(token: "")
    }

    func makeDonationReferrerTypesViewController() -> DonationReferrerTypesViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateInitialViewController() as! DonationReferrerTypesViewController
        viewController.configure(viewModel: makeDonationReferrerTypesViewModel())
        return viewController
    }

    func makeDonationReferrerTypesViewModel() -> DonationReferrerTypesViewModel {
        let dataSource = DonationReferrerTypesRemoteDataSource(
            appNetwork: appNetwork
        )
        let mapper = DonationReferrerTypesMapper()
        let repository = ReferrerTypeRepositoryImpl(
            remoteDataSource: dataSource,
            mapper: mapper
        )
        let sorter = ReferrerTypeSorter()
        let useCase = GetReferrerTypesUseCase(
            repository: repository,
            sorter: sorter
        )
        return DonationReferrerTypesViewModel(getReferrerTypesUseCase: useCase)
    }
}
