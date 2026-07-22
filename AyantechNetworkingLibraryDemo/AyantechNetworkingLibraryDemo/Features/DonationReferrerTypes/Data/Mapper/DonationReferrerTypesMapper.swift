//
//  DonationReferrerTypesMapper.swift
//  AyantechNetworkingLibraryDemo
//

struct DonationReferrerTypesMapper {
    func toDomain(_ dto: DonationReferrerTypesDTO) -> [ReferrerType] {
        dto.referrerTypeList.map {
            ReferrerType(name: $0.name, showName: $0.showName)
        }
    }
}
