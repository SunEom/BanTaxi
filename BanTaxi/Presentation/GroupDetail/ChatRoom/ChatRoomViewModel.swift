//
//  ChatRoomViewModel.swift
//  BanTaxi
//
//  Created by 엄태양 on 2023/03/12.
//

import Foundation
import RxSwift
import RxCocoa
import FirebaseAuth

struct ChatRoomViewModel {
    private let disposeBag = DisposeBag()
    private let groupInfo: GroupInfo
    private let repository: ChatRepository
    
    struct Input {
        let trigger: Driver<Void>
        let sendTrigger: Driver<Void>
        let chat: Driver<String>
    }
    
    struct Output {
        let chats: Driver<[Chat]>
    }
    
    init(groupInfo:GroupInfo, _ repo: ChatRepository = ChatRepository()) {
        self.groupInfo = groupInfo
        self.repository = repo
    }
    
    func transform(input: Input) -> Output {
        
        let chats = input.trigger
            .flatMapLatest {
                repository.addChatObserver(groupID: groupInfo.documentID)
                    .asDriver(onErrorJustReturn: [])
            }
        
        input.sendTrigger
            .withLatestFrom(input.chat)
            .asObservable()
            .withLatestFrom(UserManager.getInstance()) { chat, user in
                return Chat(uid: user!.uid, groupID: groupInfo.documentID, contents: chat, date: .now)
            }
            .subscribe(onNext : { chat in
                repository.createNewChat(chatData: chat)
            })
            .disposed(by: disposeBag)
            
        
        return Output(chats: chats)
    }
}
