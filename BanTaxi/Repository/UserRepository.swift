//
//  LoginRepository.swift
//  BanTaxi
//
//  Created by 엄태양 on 2023/03/02.
//

import Foundation
import RxSwift

struct UserRepository {
    private let network = UserNetwork()
    
    func updateNickname(with nickname: String) -> Observable<RequestResult>  {
        return network.updateNicknameFB(nickname: nickname)
            .map { result in
                if result.isSuccess {
                    UserManager.updateNickname(nickname: nickname)
                    UserManager.login(userData: localAutoLogin())
                }
                return result
            }
    }
    
    func localAutoLogin() -> User? {
        if let uid = UserDefaults.standard.string(forKey: "uid"), let nickname = UserDefaults.standard.string(forKey: "nickname"), let email = UserDefaults.standard.string(forKey: "email"), let provider = UserDefaults.standard.string(forKey: "provider") {
            return User(uid: uid, nickname: nickname, email: email, provider: provider)
        } else {
            return nil
        }
    }
    
    func logout() -> Observable<RequestResult> {
        if network.logoutFB() {
            UserManager.logout()
            return Observable.just(RequestResult(isSuccess: true, msg: "정상적으로 로그아웃 되었습니다."))
        } else {
            return Observable.just(RequestResult(isSuccess: false, msg: "오류가 발생했습니다."))
        }
    }
}
