//
//  ChatRepository.swift
//  BanTaxi
//
//  Created by 엄태양 on 2023/03/15.
//

import Foundation
import RxSwift

struct ChatRepository {
    let network = ChatNetwork()
    
    func createNewChat(chatData: Chat) {
        network.createNewChatFB(chatData: chatData)
    }
    
    func addChatObserver(groupID: String) -> Observable<[Chat]> {
        return network.setChatObserver(groupID: groupID)
    }
    
    func fetchChatNickname(with uid: String) -> Observable<String> {
        return network.fetchChatNicknameFB(with: uid)
    }
}
