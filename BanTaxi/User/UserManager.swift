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
    private static var isLogin = false
    
    private init() {}
    
    static func getInstance() -> BehaviorSubject<User?> {
        return UserManager.user
    }
    
    static func login(userData: User?) {
        if let userData = userData {
            UserDefaults.standard.setValue(userData.uid, forKey: "uid")
            UserDefaults.standard.setValue(userData.nickname, forKey: "nickname")
            UserDefaults.standard.setValue(userData.email, forKey: "email")
            UserDefaults.standard.setValue(userData.provider, forKey: "provider")
            isLogin = true
        }
        
        self.user.onNext(userData)
    }
        
    static func logout() {
        self.user.onNext(nil)
        
        UserDefaults.standard.removeObject(forKey: "uid")
        UserDefaults.standard.removeObject(forKey: "nickname")
        UserDefaults.standard.removeObject(forKey: "email")
        UserDefaults.standard.removeObject(forKey: "provider")
    }
    
    static func updateNickname(nickname: String) {
        UserDefaults.standard.setValue(nickname, forKey: "nickname")
    }
}
