//
//  MyPageViewController.swift
//  BanTaxi
//
//  Created by 엄태양 on 2023/03/03.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

class MyPageViewController: UIViewController {
    private let disposeBag = DisposeBag()
    private let viewModel: MyPageViewModel!
    
    private let imageView = UIImageView()
    private let nicknameLabel = UILabel()
    
    private let emailStackView = UIStackView()
    private let emailImageView = UIImageView(image: UIImage(systemName: "envelope"))
    private let emailLabel = UILabel()
    
    private let logoutButton = UIButton()
    
    
    init(viewModel: MyPageViewModel) {
        self.viewModel = viewModel
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
        
        let input = MyPageViewModel.Input(trigger: logoutButton.rx.tap.asDriver())
        
        let output = viewModel.transform(input: input)
        
        output.user
            .drive(onNext: {[weak self] user in
                if user == nil {
                    let vc = LoginViewController()
                    vc.modalPresentationStyle = .fullScreen
                    vc.modalTransitionStyle = .crossDissolve
                    self?.present(vc, animated: true)
                } else {
                    switch user!.provider {
                        case "apple":
                            self?.imageView.image = UIImage(systemName: "apple.logo")
                        case "google":
                            self?.imageView.image = UIImage(named: "Google")
                        default:
                            self?.imageView.image = UIImage()
                    }
                    
                    self?.nicknameLabel.text = user!.nickname
                    self?.emailLabel.text = user!.email
                }
            })
            .disposed(by: disposeBag)

    }
    
    private func attribute() {
        view.backgroundColor = .white
        self.navigationController?.navigationBar.topItem?.title = " "
        title = "마이 페이지"
        
        imageView.contentMode = .scaleAspectFill
        imageView.tintColor = .black
        
        nicknameLabel.textColor = .black
        nicknameLabel.font = .systemFont(ofSize: 25, weight: .heavy)
        nicknameLabel.textAlignment = .center
        
        emailStackView.axis = .horizontal
        emailStackView.spacing = 20
        emailImageView.tintColor = .lightGray
        emailImageView.contentMode = .scaleAspectFill
        
        emailLabel.font = .systemFont(ofSize: 13, weight: .semibold)
        emailLabel.textColor = .lightGray
        
        logoutButton.backgroundColor = K.Color.mainColor
        logoutButton.setTitle("로그아웃", for: .normal)
        logoutButton.setTitleColor(.white, for: .normal)
        logoutButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        logoutButton.layer.cornerRadius = 10
    }
    
    private func layout() {
        [imageView, nicknameLabel, emailStackView, logoutButton].forEach { view.addSubview($0) }
        
        [emailImageView, emailLabel].forEach { emailStackView.addArrangedSubview($0) }
        
        imageView.snp.makeConstraints {
            $0.width.height.equalTo(60)
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(30)
            $0.centerX.equalToSuperview()
        }
        
        nicknameLabel.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
        }
        
        emailStackView.snp.makeConstraints {
            $0.top.equalTo(nicknameLabel.snp.bottom).offset(30)
            $0.centerX.equalToSuperview()
        }
        
        emailImageView.snp.makeConstraints {
            $0.width.height.equalTo(20)
        }
        
        logoutButton.snp.makeConstraints {
            $0.top.equalTo(emailStackView.snp.bottom).offset(60)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(200)
            $0.height.equalTo(40)
        }
    }
}
