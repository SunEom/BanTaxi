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
import AuthenticationServices
import CryptoKit
import FirebaseFirestore

class LoginViewController: UIViewController {
    
    let disposeBag = DisposeBag()
    
    var currentNonce: String? // property for apple login
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "로그인"
        label.font = .systemFont(ofSize: 30, weight: .bold)
        label.textColor = .white
        return label
    }()
    
    let colorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "MainColor")
        return view
    }()
    
    let bottomView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.5
        view.layer.shadowRadius = 30
        view.layer.shadowOffset = CGSize.zero
        view.layer.masksToBounds = false
        view.layer.cornerRadius = 20
        return view
    }()
    
    let googleLoginButton: UIButton = {
        let button = UIButton()
        button.setTitle("구글로 로그인하기", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 15, weight: .semibold)
        button.setImage(UIImage(named: "Google"), for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = 5
        button.layer.borderColor = UIColor.gray.cgColor
        button.layer.borderWidth = 0.5
        button.imageEdgeInsets = UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 10)
        button.imageView?.contentMode = .scaleAspectFit
        return button
    }()
    
    let appleLoginButton: UIButton = {
        let button = UIButton()
        button.setTitle("애플로 로그인하기", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 15, weight: .semibold)
        button.setImage(UIImage(named: "Apple"), for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = 5
        button.layer.borderColor = UIColor.gray.cgColor
        button.layer.borderWidth = 0.5
        button.imageEdgeInsets = UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 10)
        button.imageView?.contentMode = .scaleAspectFit
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind(LoginViewModel())
        attribute()
        layout()
        
    }
    
    private func bind(_ viewModel: LoginViewModel) {
        googleLoginButton.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] in
                self?.googleLoginRequest()
            })
            .disposed(by: disposeBag)
        
        appleLoginButton.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] in
                self?.startSignInWithAppleFlow()
            })
            .disposed(by: disposeBag)
    }
    
    private func attribute() {
        view.backgroundColor = .white
    }
    
    private func layout() {
        [colorView, bottomView].forEach { view.addSubview($0)}
        
        colorView.addSubview(titleLabel)
        [googleLoginButton, appleLoginButton].forEach {
            bottomView.addSubview($0)
        }
        
        
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
            $0.height.equalTo(40)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
        }
        
        appleLoginButton.snp.makeConstraints {
            $0.top.equalTo(googleLoginButton.snp.bottom).offset(20)
            $0.height.equalTo(40)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
        }
    
    }
}


//MARK: - Google 로그인
extension LoginViewController {
    private func googleLoginRequest() {
        
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }

        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config

        // Start the sign in flow!
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { [unowned self] result, error in

            guard error == nil else {
                print(error?.localizedDescription)
                let alert = UIAlertController(title: "오류", message: "로그인 시도 중 발생했습니다.\n잠시후에 다시 시도해주세요.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "확인", style: .default))
                self.present(alert, animated: true)
                
                return
            }

            guard let user = result?.user, let idToken = user.idToken?.tokenString else { return }

            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: user.accessToken.tokenString)

            Auth.auth().signIn(with: credential) { authResult, error in
                if (error != nil) {
                  print(error?.localizedDescription)
                  return
                }
                
                guard let uid = authResult?.user.uid, var nickname = authResult?.user.email?.split(separator: "@").map({String($0)})[0], let email = authResult?.user.email else { return }
                
                nickname = "G" + nickname
                
                let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                
                changeRequest?.displayName = nickname
                changeRequest?.commitChanges(completion: { error in
                    print(error?.localizedDescription)
                })
                
                UserManager.login(userData: User(uid: uid, nickname: nickname, email: email, provider: "google"))
                
                let db = Firestore.firestore()
                
                db.collection("nickname").document(uid).setData(["nickname": nickname]) { error in
                    if let error = error {
                        print(error)
                    } else {
                        let vc = UINavigationController(rootViewController: MainViewController(viewModel: MainViewModel()))
                        vc.modalPresentationStyle = .fullScreen
                        vc.modalTransitionStyle = .crossDissolve
                        self.present(vc, animated: true)
                    }
                }
            }
        }
    }
}


//MARK: - Apple 로그인

extension LoginViewController{
    @available(iOS 13, *)
    func startSignInWithAppleFlow() {
      let nonce = randomNonceString()
      currentNonce = nonce
      let appleIDProvider = ASAuthorizationAppleIDProvider()
      let request = appleIDProvider.createRequest()
      request.requestedScopes = [.fullName, .email]
      request.nonce = sha256(nonce)

      let authorizationController = ASAuthorizationController(authorizationRequests: [request])
      authorizationController.delegate = self
      authorizationController.performRequests()
    }

    @available(iOS 13, *) // - 5️⃣
    private func sha256(_ input: String) -> String {
      let inputData = Data(input.utf8)
      let hashedData = SHA256.hash(data: inputData)
      let hashString = hashedData.compactMap {
        return String(format: "%02x", $0)
      }.joined()

      return hashString
    }
    
    private func randomNonceString(length: Int = 32) -> String {
      precondition(length > 0)
      let charset: [Character] =
        Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
      var result = ""
      var remainingLength = length

      while remainingLength > 0 {
        let randoms: [UInt8] = (0 ..< 16).map { _ in
          var random: UInt8 = 0
          let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
          if errorCode != errSecSuccess {
            fatalError(
              "Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)"
            )
          }
          return random
        }

        randoms.forEach { random in
          if remainingLength == 0 {
            return
          }

          if random < charset.count {
            result.append(charset[Int(random)])
            remainingLength -= 1
          }
        }
      }

      return result
    }
}

@available(iOS 13.0, *)
extension LoginViewController: ASAuthorizationControllerDelegate {

  func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            guard let nonce = currentNonce else {
                fatalError("Invalid state: A login callback was received, but no login request was sent.")
            }
            guard let appleIDToken = appleIDCredential.identityToken else {
                print("Unable to fetch identity token")
                return
            }
            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
                return
            }
            // Initialize a Firebase credential.
            let credential = OAuthProvider.credential(withProviderID: "apple.com", idToken: idTokenString, rawNonce: nonce)

            // Sign in with Firebase.
            Auth.auth().signIn(with: credential) { (authResult, error) in
                if (error != nil) {
                  print(error?.localizedDescription)
                  return
                }
                
                guard let uid = authResult?.user.uid, var nickname = authResult?.user.email?.split(separator: "@").map({String($0)})[0], let email = authResult?.user.email else { return }
                
                nickname = "A" + nickname
                
                let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                
                changeRequest?.displayName = nickname
                changeRequest?.commitChanges(completion: { error in
                    print(error?.localizedDescription)
                })
                
                UserManager.login(userData: User(uid: uid, nickname: nickname, email: email, provider: "apple"))
                
                let db = Firestore.firestore()
                
                db.collection("nickname").document(uid).setData(["nickname": nickname]) { error in
                    if let error = error {
                        print(error)
                    } else {
                        let vc = UINavigationController(rootViewController: MainViewController(viewModel: MainViewModel()))
                        vc.modalPresentationStyle = .fullScreen
                        vc.modalTransitionStyle = .crossDissolve
                        self.present(vc, animated: true)
                    }
                }
                
            }
        }
  }

  func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
    // Handle error.
    print("Sign in with Apple errored: \(error)")
  }

}
