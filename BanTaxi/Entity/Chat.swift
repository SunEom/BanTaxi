//
//  Chat.swift
//  BanTaxi
//
//  Created by 엄태양 on 2023/03/12.
//

import Foundation
import FirebaseFirestore

struct Chat {
    let uid: String
    let groupID: String
    let contents: String
    let date: Date
    
    func getDict() -> [String : Any] {
        return ["uid": uid, "groupID": groupID, "contents": contents, "date": date]
    }
    
    init(uid: String, groupID: String, contents: String, date: Date) {
        self.uid = uid
        self.groupID = groupID
        self.contents = contents
        self.date = date
    }
    
    init(data: [String:Any]) {
        uid = data["uid"] as! String
        groupID = data["groupID"] as! String
        contents = data["contents"] as! String
        date = (data["date"] as? Timestamp ?? Timestamp(date: Date())).dateValue()
    }
}
