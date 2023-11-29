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
    
    let contentView = UIView()
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(ChatBubbleCellViewController.self, forCellReuseIdentifier: K.TableViewCellID.ChatBubbleCell)
        tableView.separatorStyle = .none
        return tableView
    }()
    
    let bottomStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.spacing = 10
        return stackView
    }()
    
    let inputTextView: UITextView = {
        let textView = UITextView()
        textView.font = .systemFont(ofSize: 15)
        textView.backgroundColor = .white
        textView.textColor = .black
        textView.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        textView.layer.borderColor = UIColor.gray.cgColor
        textView.layer.cornerRadius = 20
        textView.layer.borderWidth = 0.3
        return textView
    }()
    
    let sendBtn: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "paperplane"), for: .normal)
        button.tintColor = .white
        button.layer.cornerRadius = 20
        button.backgroundColor = K.Color.mainColor
        return button
    }()
    
    init(groupInfo: GroupInfo) {
        viewModel = ChatRoomViewModel(groupInfo: groupInfo)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind()
        attribute()
        layout()
    }
    
    private func bind() {
        
        let viewWillAppear = rx.sentMessage(#selector(UIViewController.viewWillAppear(_:))).map { _ in () }.asDriver(onErrorJustReturn: ())
        
        let input = ChatRoomViewModel.Input(trigger: viewWillAppear,
                                            sendTrigger: sendBtn.rx.tap.asDriver().do(onNext:{[weak self] _ in self?.inputTextView.text = ""}),
                                            chat: inputTextView.rx.text.orEmpty.asDriver())
     
        let output = viewModel.transform(input: input)
        
        output.chats
            .drive(tableView.rx.items) { tv, row, chat in
                let indexPath = IndexPath(row: row, section: 0)
                let cell = tv.dequeueReusableCell(withIdentifier: K.TableViewCellID.ChatBubbleCell, for: indexPath) as! ChatBubbleCellViewController
                
                cell.selectionStyle = .none
                cell.setUp(viewModel: ChatBubbleCellViewModel(chat))
                
                return cell
            }
            .disposed(by: disposeBag)
    
    }
    
    private func attribute() {
        view.backgroundColor = .white
        view.addTapGesture()
    }
    
    private func layout() {
        view.addSubview(contentView)
        [tableView, bottomStackView].forEach { contentView.addSubview($0) }
    
        [inputTextView, sendBtn].forEach { bottomStackView.addArrangedSubview($0) }
        
        contentView.snp.makeConstraints {
            $0.top.bottom.leading.trailing.equalTo(view.safeAreaLayoutGuide)
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(contentView).offset(10)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(bottomStackView.snp.top)
        }
        
        bottomStackView.snp.makeConstraints {
            $0.leading.equalTo(contentView).offset(10)
            $0.trailing.equalTo(contentView).offset(-10)
            $0.bottom.equalTo(contentView).offset(-10)
            $0.height.equalTo(40)
        }
        
        sendBtn.snp.makeConstraints {
            $0.width.height.equalTo(40)
        }
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
             
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            // if keyboard size is not available for some reason, dont do anything
            return
        }
       
       // move the root view up by the distance of keyboard height
        self.view.frame.size.height -= keyboardSize.height
     }

     @objc func keyboardWillHide(notification: NSNotification) {
         guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
             // if keyboard size is not available for some reason, dont do anything
             return
         }
       // move back the root view origin to zero
         self.view.frame.size.height += keyboardSize.height
     }
    
}


