//
//  GroupInfo.swift
//  BanTaxi
//
//  Created by 엄태양 on 2023/02/28.
//

import Foundation
import FirebaseFirestore

struct GroupInfo {
    let name: String
    let time: Date
    let intake: Int
    let start: AddressData
    let destination: AddressData
    let hostUid: String
    var documentID: String
    let participants: [String]
    let participantsCount: Int
    
    func getDict() -> [String: Any] {
        return ["name":name, "time":time, "intake": intake, "start":start.getDict(), "destination":destination.getDict(), "hostUid": hostUid, "documentID": documentID, "participants": participants, "participantsCount": participantsCount]
    }
    
    init(name: String, time: Date, intake: Int, start: AddressData, destination: AddressData, hostUid: String) {
        self.name = name
        self.time = time
        self.intake = intake
        self.start = start
        self.destination = destination
        self.hostUid = hostUid
        self.documentID = ""
        self.participants = [hostUid]
        self.participantsCount =  1
    }
    
    init(data: [String: Any]) {
        self.name = data["name"] as? String ?? ""
        self.hostUid = data["hostUid"] as? String ?? ""
        self.intake = data["intake"] as? Int ?? 0
        self.time = (data["time"] as? Timestamp ?? Timestamp(date: Date())).dateValue()
        self.start = AddressData(data: data["start"] as? [String: Any] ?? [:])
        self.destination = AddressData(data: data["destination"] as? [String: Any] ?? [:])
        self.documentID = data["documentId"] as? String ?? ""
        self.participants = data["participants"] as? [String] ?? []
        self.participantsCount = data["participantsCount"] as? Int ?? 0
    }
}
