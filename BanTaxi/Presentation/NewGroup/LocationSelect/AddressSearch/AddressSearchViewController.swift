//
//  AddressSearchViewController.swift
//  BanTaxi
//
//  Created by 엄태양 on 2023/02/25.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

class AddressSearchViewController: UIViewController {
    let diseposeBag = DisposeBag()
    let viewModel : AddressSearchViewModel!
    
    let topView = UIView()
    let keywordTextField = UITextField()
    let underLine = UIView()
    let tableView = UITableView()
    
    init() {
        viewModel = AddressSearchViewModel()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind()
        attribute()
        layout()
    }
    
    private func bind() {
        
    }
    
    private func attribute() {
        view.backgroundColor = .white
        view.addTapGesture()
        
        self.navigationController?.navigationBar.topItem?.title = " "
        self.navigationController?.navigationBar.tintColor = .white
        
        topView.backgroundColor = UIColor(named: "MainColor")
        
        keywordTextField.attributedPlaceholder = NSAttributedString(string: "검색어를 입력해주세요.", attributes: [NSAttributedString.Key.foregroundColor : UIColor(white: 0.8, alpha: 1)])
        keywordTextField.tintColor = .white
        keywordTextField.textColor = .white
        keywordTextField.font = .systemFont(ofSize: 23, weight: .semibold)
        underLine.backgroundColor = UIColor(white: 0.8, alpha: 1)

    }
    
    private func layout() {
        [topView, tableView].forEach { view.addSubview($0) }
        
        [keywordTextField, underLine].forEach { topView.addSubview($0) }
        
        topView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(200)
        }
        
        keywordTextField.snp.makeConstraints {
            $0.leading.equalTo(topView).offset(40)
            $0.trailing.equalTo(topView).offset(-40)
            $0.centerY.equalTo(topView).offset(25)
            $0.height.equalTo(60)
        }
        
        underLine.snp.makeConstraints {
            $0.top.equalTo(keywordTextField.snp.bottom).offset(-5)
            $0.leading.trailing.equalTo(keywordTextField)
            $0.height.equalTo(1)
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(topView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        
    }
}