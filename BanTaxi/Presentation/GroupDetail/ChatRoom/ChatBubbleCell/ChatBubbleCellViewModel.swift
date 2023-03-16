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
    let nickname: Observable<String>
    init(_ chatData: Chat, _ repo: ChatRepository = ChatRepository() ) {
        self.chatData = chatData
        self.isMine = chatData.uid == Auth.auth().currentUser!.uid
        
        self.nickname = repo.fetchChatNickname(with: chatData.uid)
    }
}
