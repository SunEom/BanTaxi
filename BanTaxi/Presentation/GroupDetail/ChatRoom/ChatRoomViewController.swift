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
    let bottomStackView = UIStackView()
    let inputTextView = UITextView()
    let sendBtn = UIButton()
    
    init(groupInfo: GroupInfo) {
        viewModel = ChatRoomViewModel(groupInfo: groupInfo)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.addObserverRequest.onNext(Void())
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
                let indexPath = IndexPath(row: row, section: 0)
                let cell = tv.dequeueReusableCell(withIdentifier: K.TableViewCellID.ChatBubbleCell, for: indexPath) as! ChatBubbleCellViewController
                
                cell.selectionStyle = .none
                cell.setUp(with: chat)
                
                return cell
            }
            .disposed(by: disposeBag)
        
        inputTextView.rx.text
            .orEmpty
            .bind(to: viewModel.chatMsg)
            .disposed(by: disposeBag)
        
        sendBtn.rx.tap
            .map { self.inputTextView.text = "" }
            .bind(to: viewModel.sendButtonTap)
            .disposed(by: disposeBag)
        
    }
    
    private func attribute() {
        view.backgroundColor = .white
        view.addTapGesture()
        
        tableView.separatorStyle = .none
        
        bottomStackView.axis = .horizontal
        bottomStackView.distribution = .fill
        bottomStackView.alignment = .fill
        bottomStackView.spacing = 10
        
        inputTextView.font = .systemFont(ofSize: 15)
        inputTextView.backgroundColor = .white
        inputTextView.textColor = .black
        inputTextView.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        inputTextView.layer.borderColor = UIColor.gray.cgColor
        inputTextView.layer.cornerRadius = 20
        inputTextView.layer.borderWidth = 0.3
        
        sendBtn.setImage(UIImage(systemName: "paperplane"), for: .normal)
        sendBtn.tintColor = .white
        sendBtn.layer.cornerRadius = 20
        sendBtn.backgroundColor = K.Color.mainColor
    }
    
    private func layout() {
        [tableView, bottomStackView].forEach { view.addSubview($0) }
    
        [inputTextView, sendBtn].forEach { bottomStackView.addArrangedSubview($0) }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(10)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(bottomStackView.snp.top)
        }
        
        bottomStackView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(10)
            $0.trailing.equalToSuperview().offset(-10)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-10)
            $0.height.equalTo(40)
        }
        
        sendBtn.snp.makeConstraints {
            $0.width.height.equalTo(40)
        }
    }
}
