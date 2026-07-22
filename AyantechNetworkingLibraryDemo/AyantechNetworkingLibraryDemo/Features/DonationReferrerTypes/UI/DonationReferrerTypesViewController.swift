//
//  DonationReferrerTypesViewController.swift
//  AyantechNetworkingLibraryDemo
//

import Combine
import UIKit

@MainActor
final class DonationReferrerTypesViewController: UIViewController {
    @IBOutlet private weak var responseLabel: UILabel!

    var viewModel: DonationReferrerTypesViewModel!

    private var cancellables = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
    }

    @IBAction private func loadReferrerTypesButtonPressed() {
        viewModel.loadReferrerTypes()
    }

    private func bindViewModel() {
        viewModel.$state
            .sink { [weak self] state in
                self?.render(state)
            }
            .store(in: &cancellables)
    }

    private func render(_ state: DonationReferrerTypesUIState) {
        switch state {
        case .idle:
            responseLabel.text = "Tap the button to load referrer types"
        case .loading:
            responseLabel.text = "Loading…"
        case .success(let uiModels):
            responseLabel.text = uiModels
                .map(\.displayText)
                .joined(separator: "\n")
        case .error(let message):
            responseLabel.text = "Error: \(message)"
        }
    }
}
