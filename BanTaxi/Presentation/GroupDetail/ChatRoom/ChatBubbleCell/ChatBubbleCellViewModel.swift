//
//  ChatBubbleCellViewModel.swift
//  BanTaxi
//
//  Created by 엄태양 on 2023/03/12.
//

import Foundation
import RxSwift
import RxCocoa
import FirebaseAuth

struct ChatBubbleCellViewModel {
    private let disposeBag = DisposeBag()
    private let chatData: Chat
    private let repository: ChatRepository

    struct Output {
        let isMine: Driver<Bool>
        let chat: Driver<String>
        let nickname: Driver<String>
    }
    
    init(_ chatData: Chat, _ repo: ChatRepository = ChatRepository() ) {
        self.chatData = chatData
        self.repository = repo
    }
    
    func tranform() -> Output {
        let isMine = UserManager.getInstance()
            .map { $0!.uid == chatData.uid }
            .asDriver(onErrorJustReturn: false)
        
        let nickname = repository.fetchChatNickname(with: chatData.uid)
            .asDriver(onErrorJustReturn: "")
        
        return Output(isMine: isMine, chat: Driver.just(chatData.contents), nickname: nickname)
    }
}
