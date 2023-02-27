//
//  AddressSearchData.swift
//  BanTaxi
//
//  Created by 엄태양 on 2023/02/27.
//

import Foundation

struct AddressSearchData: Decodable {
    let jibunAddress: String?
    let roadAddress: String?
    let latitude: Double?
    let longitude: Double?
}
