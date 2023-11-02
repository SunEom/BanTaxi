//
//  UserManager.swift
//  BanTaxi
//
//  Created by 엄태양 on 2023/03/01.
//

import Foundation
import RxSwift
import RxRelay
import FirebaseAuth

struct UserManager {
    
    private static let user = BehaviorSubject<User?>(value: nil)
    static var isLogin = false
    
    private init() {}
    
    static func getInstance() -> BehaviorSubject<User?> {
        return UserManager.user
    }
    
    static func autoLogin() {
        if let uid = UserDefaults.standard.string(forKey: "uid"), let nickname = UserDefaults.standard.string(forKey: "nickname"), let email = UserDefaults.standard.string(forKey: "email"), let provider = UserDefaults.standard.string(forKey: "provider") {
            let userData = User(uid: uid, nickname: nickname, email: email, provider: provider)
            UserManager.login(userData: userData)
        }
    }
    
    static func login(userData: User) {
        UserDefaults.standard.setValue(userData.uid, forKey: "uid")
        UserDefaults.standard.setValue(userData.nickname, forKey: "nickname")
        UserDefaults.standard.setValue(userData.email, forKey: "email")
        UserDefaults.standard.setValue(userData.provider, forKey: "provider")
        isLogin = true
        self.user.onNext(userData)
    }
        
    static func logout() {
        
        UserDefaults.standard.removeObject(forKey: "uid")
        UserDefaults.standard.removeObject(forKey: "nickname")
        UserDefaults.standard.removeObject(forKey: "email")
        UserDefaults.standard.removeObject(forKey: "provider")
        isLogin = false
        
        self.user.onNext(nil)
    }

}
