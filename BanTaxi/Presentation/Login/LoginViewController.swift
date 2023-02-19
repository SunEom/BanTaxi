//
//  LoginViewController.swift
//  BanTaxi
//
//  Created by 엄태양 on 2023/02/19.
//

import UIKit
import RxCocoa
import RxSwift
import FirebaseAuth
import GoogleSignIn
import FirebaseCore
import SnapKit

class LoginViewController: UIViewController {
    let disposeBag = DisposeBag()
    
    let titleLabel = UILabel()
    let colorView = UIView()
    let bottomView = UIView()
    let googleLoginButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind(LoginViewModel())
        attribute()
        layout()
        
    }
    
    private func bind(_ viewModel: LoginViewModel) {
        googleLoginButton.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                self.googleLoginRequest()
            })
            .disposed(by: disposeBag)
    }
    
    private func attribute() {
        view.backgroundColor = .white
        
        colorView.backgroundColor = UIColor(named: "MainColor")
        
        bottomView.backgroundColor = .white
        bottomView.layer.shadowColor = UIColor.black.cgColor //색상
        bottomView.layer.shadowOpacity = 0.5 //alpha값
        bottomView.layer.shadowRadius = 30 //반경
        bottomView.layer.shadowOffset = CGSize.zero //위치조정
        bottomView.layer.masksToBounds = false
        bottomView.layer.cornerRadius = 20
        
        titleLabel.text = "로그인"
        titleLabel.font = .systemFont(ofSize: 30, weight: .bold)
        titleLabel.textColor = .white
        
        googleLoginButton.setTitle("구글로 로그인하기", for: .normal)
        googleLoginButton.titleLabel?.font = .systemFont(ofSize: 20, weight: .semibold)
        googleLoginButton.setImage(UIImage(named: "google"), for: .normal)
        googleLoginButton.setTitleColor(.black, for: .normal)
        googleLoginButton.layer.cornerRadius = 5
        googleLoginButton.layer.borderColor = UIColor.gray.cgColor
        googleLoginButton.layer.borderWidth = 0.5
        googleLoginButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 30)
        
    }
    
    private func layout() {
        [colorView, bottomView].forEach { view.addSubview($0)}
        
        colorView.addSubview(titleLabel)
        bottomView.addSubview(googleLoginButton)
        
        colorView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.centerX.equalToSuperview()
            $0.width.equalToSuperview()
            $0.height.equalTo(UIScreen.main.bounds.height/3)
        }
        
        bottomView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(200)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(50)
            $0.trailing.equalToSuperview()
            $0.centerY.equalToSuperview().offset(-10)
        }
        
        googleLoginButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(60)
            $0.height.equalTo(55)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
        }
    
    }
}


extension LoginViewController {
    private func googleLoginRequest() {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }

        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)
        
        // Start the sign in flow!
        GIDSignIn.sharedInstance.signIn(with: config, presenting: self) { [unowned self] user, error in

          if let error = error {
              print(error.localizedDescription)
              let alert = UIAlertController(title: "오류", message: "로그인 시도 중 발생했습니다.\n잠시후에 다시 시도해주세요.", preferredStyle: .alert)
              alert.addAction(UIAlertAction(title: "확인", style: .default))
              self.present(alert, animated: true)
              
              return
          }

          guard
            let authentication = user?.authentication,
            let idToken = authentication.idToken
          else {
            return
          }

          let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                         accessToken: authentication.accessToken)

            Auth.auth().signIn(with: credential) { authResult, error in
                if let error = error {
                    print(error.localizedDescription)
                    let alert = UIAlertController(title: "오류", message: "오류가 발생했습니다.\n잠시후에 다시 시도해주세요.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "확인", style: .default))
                    self.present(alert, animated: true)
                    return
                }
                
                if let authResult = authResult {
                    print(authResult.user.displayName)
                }
            }
        }
    }
}
