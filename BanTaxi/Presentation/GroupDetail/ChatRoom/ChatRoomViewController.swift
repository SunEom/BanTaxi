//
//  ChatRoomViewController.swift
//  BanTaxi
//
//  Created by 엄태양 on 2023/03/12.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

class ChatRoomViewController: UIViewController {
    let disposeBag = DisposeBag()
    let viewModel: ChatRoomViewModel
    
    let tableView = UITableView()
    let inputTextView = UITextView()
    let sendBtn = UIButton()
    
    init(groupInfo: GroupInfo) {
        viewModel = ChatRoomViewModel(groupInfo: groupInfo)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(ChatBubbleCellViewController.self, forCellReuseIdentifier: K.TableViewCellID.ChatBubbleCell)
        
        bind()
        attribute()
        layout()
    }
    
    private func bind() {
        
        
        viewModel.chatList
            .bind(to: tableView.rx.items) { tv, row, chat in
                let cell = tv.dequeueReusableCell(withIdentifier: K.TableViewCellID.ChatBubbleCell, for: IndexPath(row: row, section: 0)) as! ChatBubbleCellViewController
                cell.selectionStyle = .none
                cell.setUp(with: chat)
                return cell
            }
            .disposed(by: disposeBag)
    }
    
    private func attribute() {
        view.addTapGesture()
        view.backgroundColor = .white
        title = viewModel.groupInfo.name
        
        tableView.backgroundColor = .white
        tableView.separatorStyle = .none
        
        inputTextView.font = .systemFont(ofSize: 15)
        inputTextView.backgroundColor = .white
        inputTextView.textColor = .black
        inputTextView.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        inputTextView.layer.cornerRadius = 20
        inputTextView.layer.borderWidth = 1.0
        inputTextView.layer.borderColor = UIColor.black.cgColor
    
        
        sendBtn.backgroundColor = K.Color.mainColor
        sendBtn.layer.cornerRadius = 20
        sendBtn.setImage(UIImage(systemName: "paperplane"), for: .normal)
        sendBtn.tintColor = .white
    }
    
    private func layout() {
        [tableView, inputTextView, sendBtn].forEach {
            view.addSubview($0)
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(inputTextView.snp.top).offset(-10)
        }
        
        inputTextView.snp.makeConstraints {
            $0.height.equalTo(40)
            $0.leading.equalToSuperview().offset(10)
            $0.trailing.equalTo(sendBtn.snp.leading).offset(-10)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-10)
        }
        
        sendBtn.snp.makeConstraints {
            $0.height.width.equalTo(40)
            $0.trailing.equalToSuperview().offset(-10)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-10)
        }
        
    }
}
