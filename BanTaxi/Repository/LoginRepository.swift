//
//  LoginRepository.swift
//  BanTaxi
//
//  Created by 엄태양 on 2023/03/02.
//

import Foundation

struct LoginRepository {
    func localAutoLogin() -> User? {
        if let uid = UserDefaults.standard.string(forKey: "uid"), let nickname = UserDefaults.standard.string(forKey: "nickname") {
            return User(uid: uid, nickname: nickname)
        } else {
            return nil
        }
    }
}
