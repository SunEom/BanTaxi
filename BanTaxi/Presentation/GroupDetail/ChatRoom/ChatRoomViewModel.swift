//
//  ChatRoomViewModel.swift
//  BanTaxi
//
//  Created by 엄태양 on 2023/03/12.
//

import Foundation
import RxSwift
import RxRelay
import FirebaseAuth

struct ChatRoomViewModel {
    let disposeBag = DisposeBag()
    let groupInfo: GroupInfo
//    let chatList = PublishSubject<[Chat]>()
    let chatList = Observable.just([Chat(uid: "123123", groupID: "12312312", contents: "안녕하세요", date: "2023-03-12"), Chat(uid: Auth.auth().currentUser!.uid, groupID: "12312312", contents: "안녕하세요2", date: "2023-03-12"), Chat(uid: "123123", groupID: "12312312", contents: "안녕하세요3", date: "2023-03-12")])
    
    init(groupInfo:GroupInfo) {
        self.groupInfo = groupInfo
    }
}
