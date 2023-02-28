//
//  GroupInfo.swift
//  BanTaxi
//
//  Created by 엄태양 on 2023/02/28.
//

import Foundation

struct GroupInfo {
    let name: String
    let time: Date
    let intake: Int
    let start: AddressData
    let destination: AddressData
    
    enum CodingKeys: String, CodingKey {
        case name
        case time
        case intake
        case start
        case destination
    }
    
    func getDict() -> [String: Any] {
        return ["name":name, "time":time, "intake": intake, "start":start.getDict(), "destination":destination.getDict()]
    }
}
