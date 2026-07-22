//
//  AppDependencies.swift
//  AyantechNetworkingLibraryDemo
//

@MainActor
final class AppDependencies {
    private let appNetwork: AppNetwork

    init() {
        appNetwork = AppNetwork(token: "")
    }

    func makeDonationReferrerTypesViewModel() -> DonationReferrerTypesViewModel {
        let dataSource = DonationReferrerTypesRemoteDataSource(
            appNetwork: appNetwork,
            url: "https://application.billingsystem.ayantech.ir/WebServices/Core.svc/DonationServiceGerReferrerTypeList"
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
