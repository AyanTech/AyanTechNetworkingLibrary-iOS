//
//  ATErrorMapper.swift
//  AyantechNetworkingLibraryDemo
//

import AyanTechNetworkingLibrary
import Foundation

struct ATErrorMapper {
    func toATError(_ error: Error) -> ATError {
        if let atError = error as? ATError {
            return atError
        }

        let atError = ATError.generalError
        atError.persianDescription = error.localizedDescription
        return atError
    }
}
