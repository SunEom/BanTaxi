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
    
    let buttonStackView = UIStackView()
    let newGroupButton = UIButton()
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
    
        buttonStackView.axis = .vertical
        buttonStackView.distribution = .fillEqually
        buttonStackView.spacing = 0
        [newGroupButton, searchButton].forEach {
            $0.backgroundColor = UIColor(named: "MainColor")
            $0.layer.borderWidth = 0.5
            $0.layer.borderColor = UIColor.white.cgColor
        }
        
        let newGroupButtonConfig = UIImage.SymbolConfiguration(pointSize: 40, weight: .semibold, scale: .default)
        let newGroupButtonImg = UIImage(systemName: "person.3", withConfiguration: newGroupButtonConfig)?.withRenderingMode(.alwaysTemplate)
        newGroupButton.setTitle("새로운 그룹 만들기!", for: .normal)
        newGroupButton.setImage(newGroupButtonImg, for: .normal)
        newGroupButton.tintColor = .white
        newGroupButton.titleLabel?.font = .systemFont(ofSize: 30, weight: .bold)
        newGroupButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 20)
        newGroupButton.imageView?.contentMode = .scaleAspectFit
        
        let searchButtonConfig = UIImage.SymbolConfiguration(pointSize: 40, weight: .semibold, scale: .default)
        let searchButtonImg = UIImage(systemName: "magnifyingglass", withConfiguration: searchButtonConfig)?.withRenderingMode(.alwaysTemplate)
        searchButton.setTitle("기존 그룹에서 찾아보기", for: .normal)
        searchButton.setImage(searchButtonImg, for: .normal)
        searchButton.tintColor = .white
        searchButton.titleLabel?.font = .systemFont(ofSize: 30, weight: .bold)
        searchButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 20)
        searchButton.imageView?.contentMode = .scaleAspectFit
    }
    
    private func layout() {
        [titleLabel, buttonStackView].forEach {
            view.addSubview($0)
        }
        
        [newGroupButton, searchButton].forEach {
            buttonStackView.addArrangedSubview($0)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            $0.trailing.equalToSuperview()
            $0.leading.equalToSuperview().offset(30)
            $0.height.equalTo(40)
        }
        
        buttonStackView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(50)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        
    }
}
