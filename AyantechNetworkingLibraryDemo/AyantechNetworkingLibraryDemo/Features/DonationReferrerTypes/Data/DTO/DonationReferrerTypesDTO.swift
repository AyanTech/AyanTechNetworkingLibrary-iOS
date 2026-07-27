//
//  DonationReferrerTypesDTO.swift
//  AyantechNetworkingLibraryDemo
//

struct DonationReferrerTypesRequestDTO: Encodable, Sendable {}

struct DonationReferrerTypesDTO: Decodable, Sendable {
    let referrerTypeList: [ReferrerTypeDTO]

    enum CodingKeys: String, CodingKey {
        case referrerTypeList = "ReferrerTypeList"
    }
}

struct ReferrerTypeDTO: Decodable, Sendable {
    let name: String
    let showName: String

    enum CodingKeys: String, CodingKey {
        case name = "Name"
        case showName = "ShowName"
    }
}
