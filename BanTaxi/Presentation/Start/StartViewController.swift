//
//  StartViewController.swift
//  BanTaxi
//
//  Created by 엄태양 on 2023/02/19.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

class StartViewController: UIViewController {
    let disposeBag = DisposeBag()
    let titleLabel = UILabel()
    let viewModel: StartViewModel!
    
    init() {
        viewModel = StartViewModel()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        attribute()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        viewModel.loginRequest.onNext(Void())
    }
    
    private func bind() {
        viewModel.loginCheckFinished
            .observe(on: MainScheduler.instance)
            .withLatestFrom(UserManager.getInstance())
            .subscribe(onNext: {
                if $0 == nil {
                    let vc = LoginViewController()
                    vc.modalPresentationStyle = .fullScreen
                    vc.modalTransitionStyle = .crossDissolve
                    self.present(vc, animated: true)
                } else {
                    let vc = MainViewController()
                    vc.modalPresentationStyle = .fullScreen
                    vc.modalTransitionStyle = .crossDissolve
                    self.present(vc, animated: true)
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func attribute() {
        
        view.backgroundColor = UIColor(named: "MainColor")
        titleLabel.textColor = .white
        titleLabel.text = "BanTaxi"
        titleLabel.font = .systemFont(ofSize: 36, weight: .bold)
        
    }
    
    private func layout() {
        [titleLabel].forEach { view.addSubview($0) }
        
        titleLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
}
