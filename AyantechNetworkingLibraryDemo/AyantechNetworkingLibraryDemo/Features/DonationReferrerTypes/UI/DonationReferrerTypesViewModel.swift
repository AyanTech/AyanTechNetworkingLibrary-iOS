//
//  DonationReferrerTypesViewModel.swift
//  AyantechNetworkingLibraryDemo
//

import AyanTechNetworkingLibrary
import Combine
import Foundation

@MainActor
final class DonationReferrerTypesViewModel {
    @Published private(set) var state: DonationReferrerTypesUIState = .idle

    private let getReferrerTypesUseCase: GetReferrerTypesUseCase
    private var requestCancellable: AnyCancellable?

    init(getReferrerTypesUseCase: GetReferrerTypesUseCase) {
        self.getReferrerTypesUseCase = getReferrerTypesUseCase
    }

    func loadReferrerTypes() {
        state = .loading
        requestCancellable = getReferrerTypesUseCase.execute()
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    guard case .failure(let error) = completion else { return }
                    self?.state = .error(
                        error.persianDescription ?? "Unknown error"
                    )
                },
                receiveValue: { [weak self] referrerTypes in
                    let uiModels = referrerTypes.map {
                        ReferrerTypeUIModel(
                            displayText: "\($0.showName) (\($0.name))"
                        )
                    }
                    self?.state = .success(uiModels)
                }
            )
    }
}
