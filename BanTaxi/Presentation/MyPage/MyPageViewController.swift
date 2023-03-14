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
    let disposeBag = DisposeBag()
    let viewModel: MyPageViewModel!
    
    let editButton = UIBarButtonItem(image: UIImage(systemName: "square.and.pencil"), style: .plain, target: nil, action: nil)
    
    let imageView = UIImageView()
    let nicknameLabel = UILabel()
    
    let emailStackView = UIStackView()
    let emailImageView = UIImageView(image: UIImage(systemName: "envelope"))
    let emailLabel = UILabel()
    
    let logoutButton = UIButton()
    
    
    init() {
        viewModel = MyPageViewModel()
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
        viewModel.user
            .map { $0?.provider }
            .map { provider in
                switch provider {
                    case "apple":
                        return UIImage(systemName: "apple.logo")
                    case "google":
                        return UIImage(named: "Google")
                    default:
                        return UIImage()
                }
            }
            .bind(to: imageView.rx.image)
            .disposed(by: disposeBag)

        
        viewModel.user
            .map{ $0?.nickname ?? "" }
            .bind(to: nicknameLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.user
            .map { $0?.email ?? ""}
            .bind(to: emailLabel.rx.text)
            .disposed(by: disposeBag)
        
        logoutButton.rx.tap
            .bind(to: viewModel.logoutButtonTap)
            .disposed(by: disposeBag)
        
        viewModel.logoutResult
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { result in
                if result.isSuccess {
                    self.dismiss(animated: true)
                }
            })
            .disposed(by: disposeBag)
    
        editButton.rx.tap
            .asDriver()
            .drive(onNext: {
                self.navigationController?.pushViewController(NicknameEditViewController(), animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    private func attribute() {
        view.backgroundColor = .white
        self.navigationController?.navigationBar.topItem?.title = " "
        title = "마이 페이지"
        
        navigationItem.rightBarButtonItem = editButton
        navigationItem.rightBarButtonItem?.tintColor = K.Color.mainColor
        
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
