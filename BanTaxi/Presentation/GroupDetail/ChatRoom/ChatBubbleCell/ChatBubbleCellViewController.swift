//
//  ChatBubbleCellViewController.swift
//  BanTaxi
//
//  Created by 엄태양 on 2023/03/12.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

class ChatBubbleCellViewController: UITableViewCell {
    let disposeBag = DisposeBag()
    var viewModel: ChatBubbleCellViewModel!
    let otherChat = UITextView()
    let myChat = UITextView()
    
    
    func setUp(with chatData: Chat) {
        viewModel = ChatBubbleCellViewModel(chatData)
        attribute()
        layout()
    }
    
    private func attribute(){
        backgroundColor = .white
        otherChat.backgroundColor = .lightGray
        myChat.backgroundColor = K.Color.mainColor
        [otherChat, myChat].forEach {
            $0.text = self.viewModel.chatData.contents
            $0.textColor = .black
            $0.isEditable = false
            $0.isScrollEnabled = false
            $0.font = .systemFont(ofSize: 15)
            $0.layer.cornerRadius = 5
            $0.textContainer.lineFragmentPadding = 10
        }
        myChat.textColor = .white
        
        myChat.isHidden = !viewModel.isMine
        otherChat.isHidden = viewModel.isMine
    }
    
    private func layout() {
        [otherChat, myChat].forEach {
            contentView.addSubview($0)
        }
        
        otherChat.snp.makeConstraints {
            $0.top.equalTo(contentView).offset(10)
            $0.leading.equalTo(contentView).offset(20)
            $0.width.lessThanOrEqualTo(K.ScreenSize.width*(2/3))
        }
        
        myChat.snp.makeConstraints {
            $0.top.equalTo(contentView).offset(10)
            $0.trailing.equalTo(contentView).offset(-20)
            $0.width.lessThanOrEqualTo(K.ScreenSize.width*(2/3))
        }
        
        contentView.snp.makeConstraints {
            $0.leading.trailing.equalTo(self)
            $0.bottom.equalTo(otherChat.snp.bottom).offset(10)
            $0.bottom.equalTo(myChat.snp.bottom).offset(10)
        }
    }
}
