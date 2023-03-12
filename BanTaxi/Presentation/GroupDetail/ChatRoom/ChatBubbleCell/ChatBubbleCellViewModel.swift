//
//  ChatBubbleCellViewModel.swift
//  BanTaxi
//
//  Created by 엄태양 on 2023/03/12.
//

import Foundation
import RxSwift
import RxRelay
import FirebaseAuth

struct ChatBubbleCellViewModel {
    let disposeBag = DisposeBag()
    let isMine: Bool
    let chatData: Chat
    
    init(_ chatData: Chat) {
        self.chatData = chatData
        self.isMine = chatData.uid == Auth.auth().currentUser!.uid
    }
}
