//
//  MainViewController.swift
//  BanTaxi
//
//  Created by 엄태양 on 2023/02/22.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

class MainViewController: UIViewController {
    private let disposeBag = DisposeBag()
    private let viewModel: MainViewModel
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "BanTaxi"
        label.font = .systemFont(ofSize: 30, weight: .heavy)
        label.textColor = UIColor(named: "MainColor")
        return label
    }()
    
    private let profileButton: UIButton = {
        let button = UIButton()
        let profileButtonConfig = UIImage.SymbolConfiguration(pointSize: 30, weight: .regular, scale: .default)
        let profileButtonImg = UIImage(systemName: "person.circle", withConfiguration: profileButtonConfig)?.withRenderingMode(.alwaysTemplate)
        button.tintColor = UIColor(named: "MainColor")
        button.setImage(profileButtonImg, for: .normal)
        return button
    }()
    
    private let buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 30
        return stackView
    }()
    
    private let newGroupButton: UIButton = {
        let button = UIButton()
        let newGroupButtonConfig = UIImage.SymbolConfiguration(pointSize: 30, weight: .semibold, scale: .default)
        let newGroupButtonImg = UIImage(systemName: "person.3", withConfiguration: newGroupButtonConfig)?.withRenderingMode(.alwaysTemplate)
        button.setTitle("새 그룹 만들기", for: .normal)
        button.setImage(newGroupButtonImg, for: .normal)
        button.tintColor = .white
        button.titleLabel?.font = .systemFont(ofSize: 25, weight: .bold)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 20)
        button.imageView?.contentMode = .scaleAspectFit
        button.layer.cornerRadius = 20
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.3
        button.layer.shadowRadius = 20
        button.layer.shadowOffset = CGSize.zero
        button.layer.masksToBounds = false
        button.backgroundColor = UIColor(named: "MainColor")
        return button
    }()
    
    private let myGroupButton: UIButton = {
        let button = UIButton()
        let myGroupButtonConfig = UIImage.SymbolConfiguration(pointSize: 30, weight: .semibold, scale: .default)
        let myGroupButtonImg = UIImage(systemName: "list.star", withConfiguration: myGroupButtonConfig)?.withRenderingMode(.alwaysTemplate)
        button.setTitle("내 그룹 보기", for: .normal)
        button.setTitleColor(UIColor(named: "MainColor"), for: .normal)
        button.setImage(myGroupButtonImg, for: .normal)
        button.tintColor = UIColor(named: "MainColor")
        button.titleLabel?.font = .systemFont(ofSize: 25, weight: .bold)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 20)
        button.imageView?.contentMode = .scaleAspectFit
        button.layer.cornerRadius = 20
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.3
        button.layer.shadowRadius = 20
        button.layer.shadowOffset = CGSize.zero
        button.layer.masksToBounds = false
        button.backgroundColor = .white
        return button
    }()
    
    private let searchButton: UIButton = {
        let button = UIButton()
        let searchButtonConfig = UIImage.SymbolConfiguration(pointSize: 30, weight: .semibold, scale: .default)
        let searchButtonImg = UIImage(systemName: "magnifyingglass", withConfiguration: searchButtonConfig)?.withRenderingMode(.alwaysTemplate)
        button.setTitle("그룹 찾기", for: .normal)
        button.setTitleColor(UIColor(named: "MainColor"), for: .normal)
        button.setImage(searchButtonImg, for: .normal)
        button.tintColor = UIColor(named: "MainColor")
        button.titleLabel?.font = .systemFont(ofSize: 25, weight: .bold)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 20)
        button.imageView?.contentMode = .scaleAspectFit
        button.layer.cornerRadius = 20
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.3
        button.layer.shadowRadius = 20
        button.layer.shadowOffset = CGSize.zero
        button.layer.masksToBounds = false
        button.backgroundColor = .white
        return button
    }()
    
    init(viewModel: MainViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        uiEvent()
        attribute()
        layout()
    }
    
    private func uiEvent() {
        profileButton.rx.tap
            .asDriver()
            .drive(onNext: {
                self.navigationController?.pushViewController(MyPageViewController(viewModel: MyPageViewModel()), animated: true)
            })
            .disposed(by: disposeBag)
        
        newGroupButton.rx.tap
            .asDriver()
            .drive(onNext: {
                self.navigationController?.pushViewController(NewGroupViewController(viewModel: NewGroupViewModel()), animated: true)
            })
            .disposed(by: disposeBag)
        
        myGroupButton.rx.tap
            .asDriver()
            .drive(onNext: {
                self.navigationController?.pushViewController(MyGroupViewController(), animated: true)
            })
            .disposed(by: disposeBag)
        
        searchButton.rx.tap
            .asDriver()
            .drive(onNext: {
                self.navigationController?.pushViewController(SearchViewController(viewModel: SearchViewModel()), animated: true)
            })
            .disposed(by: disposeBag)
        
        
    }
    
    private func attribute() {
        view .backgroundColor = .white
        self.navigationController?.navigationBar.tintColor = UIColor(named: "MainColor")
    }
    
    private func layout() {
        [titleLabel, profileButton, buttonStackView].forEach {
            view.addSubview($0)
        }
        
        [newGroupButton, myGroupButton, searchButton].forEach {
            buttonStackView.addArrangedSubview($0)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.trailing.equalToSuperview()
            $0.leading.equalToSuperview().offset(30)
            $0.height.equalTo(40)
        }
        
        profileButton.snp.makeConstraints {
            $0.centerY.equalTo(titleLabel)
            $0.trailing.equalToSuperview().offset(-30)
        }
        
        buttonStackView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(50)
            $0.leading.equalToSuperview().offset(30)
            $0.trailing.equalToSuperview().offset(-30)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-20)
        }
        
    }
}
