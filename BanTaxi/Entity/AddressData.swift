//
//  AddressSearchResult.swift
//  BanTaxi
//
//  Created by 엄태양 on 2023/02/26.
//

import Foundation

struct AddressData: Codable { // 임시 데이터를 위한 구조체
    var roadAddress: String?
    var jibunAddress: String?
    var latitude: Double?
    var longitude: Double?
    var latitudeStr: String?
    var longitudeStr: String?
    var placeName: String?
    
    init(roadAddress: String?, jibunAddress: String?, latitude: Double?, longitude: Double?, placeName: String?) {
        self.roadAddress = roadAddress
        self.jibunAddress = jibunAddress
        self.latitude = latitude
        self.longitude = longitude
        self.latitudeStr = latitude != nil ? "\(latitude!)" : ""
        self.longitudeStr = longitude != nil ? "\(longitude!)" : ""
        self.placeName = placeName
    }
    
    enum CodingKeys: String, CodingKey {
        case latitude, longitude
        case roadAddress = "address_name"
        case jibunAddress = "road_address_name"
        case latitudeStr = "y"
        case longitudeStr = "x"
        case placeName = "place_name"
    }
}


struct AddressResponseData: Codable {
    var documents: [AddressData]?
    let errorType: String?
    let message: String?
}
