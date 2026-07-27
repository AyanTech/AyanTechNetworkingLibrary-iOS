//
//  ReferrerTypeSorter.swift
//  AyantechNetworkingLibraryDemo
//

struct ReferrerTypeSorter {
    func sortByName(_ referrerTypes: [ReferrerType]) -> [ReferrerType] {
        referrerTypes.sorted { $0.name < $1.name }
    }
}
