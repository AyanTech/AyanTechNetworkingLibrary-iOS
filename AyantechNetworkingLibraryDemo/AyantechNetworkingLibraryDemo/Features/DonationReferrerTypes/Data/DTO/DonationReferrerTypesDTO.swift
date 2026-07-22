//
//  DonationReferrerTypesDTO.swift
//  AyantechNetworkingLibraryDemo
//

struct DonationReferrerTypesRequestDTO: Encodable {}

struct DonationReferrerTypesDTO: Decodable {
    let referrerTypeList: [ReferrerTypeDTO]

    enum CodingKeys: String, CodingKey {
        case referrerTypeList = "ReferrerTypeList"
    }
}

struct ReferrerTypeDTO: Decodable {
    let name: String
    let showName: String

    enum CodingKeys: String, CodingKey {
        case name = "Name"
        case showName = "ShowName"
    }
}
