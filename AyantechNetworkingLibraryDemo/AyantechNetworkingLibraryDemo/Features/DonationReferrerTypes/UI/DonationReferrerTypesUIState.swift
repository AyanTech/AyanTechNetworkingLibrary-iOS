//
//  DonationReferrerTypesUIState.swift
//  AyantechNetworkingLibraryDemo
//

enum DonationReferrerTypesUIState: Sendable {
    case idle
    case loading
    case success([ReferrerTypeUIModel])
    case error(String)
}
