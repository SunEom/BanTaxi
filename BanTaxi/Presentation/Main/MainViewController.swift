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
    let disposeBag = DisposeBag()
    let viewModel: MainViewModel!
    
    let titleLabel = UILabel()
    let profileButton = UIButton()
    
    let buttonStackView = UIStackView()
    let newGroupButton = UIButton()
    let myGroupButton = UIButton()
    let searchButton = UIButton()
    init() {
        viewModel = MainViewModel()
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
        newGroupButton.rx.tap
            .asDriver()
            .drive(onNext: {
                self.navigationController?.pushViewController(NewGroupViewController(), animated: true)
            })
            .disposed(by: disposeBag)
        
        searchButton.rx.tap
            .asDriver()
            .drive(onNext: {
                self.navigationController?.pushViewController(SearchViewController(), animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    private func attribute() {
        view .backgroundColor = .white
        
        self.navigationController?.navigationBar.tintColor = UIColor(named: "MainColor")
        
        titleLabel.text = "BanTaxi"
        titleLabel.font = .systemFont(ofSize: 30, weight: .heavy)
        titleLabel.textColor = UIColor(named: "MainColor")
    
        let profileButtonConfig = UIImage.SymbolConfiguration(pointSize: 30, weight: .regular, scale: .default)
        let profileButtonImg = UIImage(systemName: "person.circle", withConfiguration: profileButtonConfig)?.withRenderingMode(.alwaysTemplate)
        profileButton.tintColor = UIColor(named: "MainColor")
        profileButton.setImage(profileButtonImg, for: .normal)
        
        buttonStackView.axis = .vertical
        buttonStackView.distribution = .fillEqually
        buttonStackView.spacing = 30
        [newGroupButton].forEach {
            $0.backgroundColor = UIColor(named: "MainColor")
        }
        
        [myGroupButton, searchButton].forEach {
            $0.backgroundColor = .white
        }
        
        let newGroupButtonConfig = UIImage.SymbolConfiguration(pointSize: 30, weight: .semibold, scale: .default)
        let newGroupButtonImg = UIImage(systemName: "person.3", withConfiguration: newGroupButtonConfig)?.withRenderingMode(.alwaysTemplate)
        newGroupButton.setTitle("새 그룹 만들기", for: .normal)
        newGroupButton.setImage(newGroupButtonImg, for: .normal)
        newGroupButton.tintColor = .white
        newGroupButton.titleLabel?.font = .systemFont(ofSize: 25, weight: .bold)
        newGroupButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 20)
        newGroupButton.imageView?.contentMode = .scaleAspectFit
        newGroupButton.layer.cornerRadius = 20
        newGroupButton.layer.shadowColor = UIColor.black.cgColor
        newGroupButton.layer.shadowOpacity = 0.3
        newGroupButton.layer.shadowRadius = 20
        newGroupButton.layer.shadowOffset = CGSize.zero
        newGroupButton.layer.masksToBounds = false
        
        let myGroupButtonConfig = UIImage.SymbolConfiguration(pointSize: 30, weight: .semibold, scale: .default)
        let myGroupButtonImg = UIImage(systemName: "list.star", withConfiguration: myGroupButtonConfig)?.withRenderingMode(.alwaysTemplate)
        myGroupButton.setTitle("내 그룹 보기", for: .normal)
        myGroupButton.setTitleColor(UIColor(named: "MainColor"), for: .normal)
        myGroupButton.setImage(myGroupButtonImg, for: .normal)
        myGroupButton.tintColor = UIColor(named: "MainColor")
        myGroupButton.titleLabel?.font = .systemFont(ofSize: 25, weight: .bold)
        myGroupButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 20)
        myGroupButton.imageView?.contentMode = .scaleAspectFit
        myGroupButton.layer.cornerRadius = 20
        myGroupButton.layer.shadowColor = UIColor.black.cgColor
        myGroupButton.layer.shadowOpacity = 0.3
        myGroupButton.layer.shadowRadius = 20
        myGroupButton.layer.shadowOffset = CGSize.zero
        myGroupButton.layer.masksToBounds = false
        
        let searchButtonConfig = UIImage.SymbolConfiguration(pointSize: 30, weight: .semibold, scale: .default)
        let searchButtonImg = UIImage(systemName: "magnifyingglass", withConfiguration: searchButtonConfig)?.withRenderingMode(.alwaysTemplate)
        searchButton.setTitle("그룹 찾기", for: .normal)
        searchButton.setTitleColor(UIColor(named: "MainColor"), for: .normal)
        searchButton.setImage(searchButtonImg, for: .normal)
        searchButton.tintColor = UIColor(named: "MainColor")
        searchButton.titleLabel?.font = .systemFont(ofSize: 25, weight: .bold)
        searchButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 20)
        searchButton.imageView?.contentMode = .scaleAspectFit
        searchButton.layer.cornerRadius = 20
        searchButton.layer.shadowColor = UIColor.black.cgColor
        searchButton.layer.shadowOpacity = 0.3
        searchButton.layer.shadowRadius = 20
        searchButton.layer.shadowOffset = CGSize.zero
        searchButton.layer.masksToBounds = false
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
