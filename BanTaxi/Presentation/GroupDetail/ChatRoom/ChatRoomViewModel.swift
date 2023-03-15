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
    let chatList = PublishSubject<[Chat]>()
    
    let addObserverRequest = PublishSubject<Void>()

    let chatMsg = PublishSubject<String>()
    let sendButtonTap = PublishRelay<Void>()
    
    init(groupInfo:GroupInfo, _ repo: ChatRepository = ChatRepository()) {
        self.groupInfo = groupInfo
        
        addObserverRequest
            .flatMapLatest{ repo.addChatObserver(groupID: groupInfo.documentID) }
            .bind(to: chatList)
            .disposed(by: disposeBag)
        
        sendButtonTap
            .withLatestFrom(chatMsg)
            .filter { $0 != "" }
            .withLatestFrom(UserManager.getInstance()) { contents, user in
                return Chat(uid: user!.uid, groupID: groupInfo.documentID, contents: contents, date: Date())
            }
            .subscribe(onNext: { repo.createNewChat(chatData: $0) })
            .disposed(by: disposeBag)
        
        
    }
}
