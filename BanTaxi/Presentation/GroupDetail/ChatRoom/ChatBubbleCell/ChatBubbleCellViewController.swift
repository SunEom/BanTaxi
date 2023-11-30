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
    private let disposeBag = DisposeBag()
    private var viewModel: ChatBubbleCellViewModel!
    private let otherChat: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = UIColor(white: 0.9, alpha: 1)
        textView.textColor = .black
        textView.isEditable = false
        textView.isScrollEnabled = false
        textView.font = .systemFont(ofSize: 15)
        textView.layer.cornerRadius = 5
        textView.textContainer.lineFragmentPadding = 10
        return textView
    }()
    
    private let myChat: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = K.Color.mainColor
        textView.textColor = .white
        textView.isEditable = false
        textView.isScrollEnabled = false
        textView.font = .systemFont(ofSize: 15)
        textView.layer.cornerRadius = 5
        textView.textContainer.lineFragmentPadding = 10
        return textView
    }()
    
    private let nicknameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .bold)
        return label
    }()
    
    
    func setUp(viewModel: ChatBubbleCellViewModel) {
        self.viewModel = viewModel
        
        bind()
        attribute()
        layout()
    }
    
    private func bind() {
        
        let output = viewModel.tranform()
        
        output.nickname
            .drive(nicknameLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.chat
            .drive(myChat.rx.text)
            .disposed(by: disposeBag)
        
        output.chat
            .drive(otherChat.rx.text)
            .disposed(by: disposeBag)
        
        output.isMine
            .drive(otherChat.rx.isHidden)
            .disposed(by: disposeBag)
        
        output.isMine
            .drive(nicknameLabel.rx.isHidden)
            .disposed(by: disposeBag)
        
        output.isMine
            .map { !$0 }
            .drive(myChat.rx.isHidden)
            .disposed(by: disposeBag)
        
    }
    
    private func attribute(){
        backgroundColor = .white
    }
    
    private func layout() {
        [nicknameLabel, otherChat, myChat].forEach {
            contentView.addSubview($0)
        }
        
        nicknameLabel.snp.makeConstraints {
            $0.top.equalTo(contentView.snp.top).offset(10)
            $0.leading.equalTo(contentView).offset(20)
            $0.trailing.equalTo(contentView).offset(-20)
        }
        
        otherChat.snp.makeConstraints {
            $0.top.equalTo(nicknameLabel.snp.bottom).offset(5)
            $0.leading.equalTo(nicknameLabel)
            $0.width.lessThanOrEqualTo(K.ScreenSize.width*(2/3))
            $0.bottom.equalTo(contentView).offset(-10)
        }
        
        myChat.snp.makeConstraints {
            $0.top.equalTo(contentView).offset(10)
            $0.trailing.equalTo(contentView).offset(-20)
            $0.width.lessThanOrEqualTo(K.ScreenSize.width*(2/3))
            $0.bottom.equalTo(contentView).offset(-10)
        }
        
    
    }
}
