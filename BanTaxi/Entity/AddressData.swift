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
    
    init(data: [String: Any]) {
        self.roadAddress = data["roadAddress"] as? String ?? ""
        self.jibunAddress = data["jibunAddress"] as? String ?? ""
        self.latitude = data["latitude"] as? Double ?? 0.0
        self.longitude = data["longitude"] as? Double ?? 0.0
        self.latitudeStr = data["latitudeStr"] as? String ?? ""
        self.longitudeStr = data["longitudeStr"] as? String ?? ""
        self.placeName = data["placeName"] as? String ?? ""
    }
    
    enum CodingKeys: String, CodingKey {
        case latitude, longitude
        case roadAddress = "address_name"
        case jibunAddress = "road_address_name"
        case latitudeStr = "y"
        case longitudeStr = "x"
        case placeName = "place_name"
    }
    
    func getDict() -> [String:Any] {
        return [
            "roadAddress": roadAddress ?? "",
            "jibunAddress": jibunAddress ?? "",
            "latitude": latitude ?? 0,
            "longitude": longitude ?? 0,
            "latitudeStr": latitudeStr ?? "",
            "longitudeStr": longitudeStr ?? "",
            "placeName": placeName ?? "",
        ]
    }
}


struct AddressResponseData: Codable {
    var documents: [AddressData]?
    let errorType: String?
    let message: String?
}
