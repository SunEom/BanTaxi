//
//  AuthNetwork.swift
//  BanTaxi
//
//  Created by 엄태양 on 2023/03/03.
//

import Foundation
import FirebaseAuth

struct AuthNetwork {
    func logoutFB() -> Bool {
        do {
            try Auth.auth().signOut()
            return true
        } catch (let error) {
            print(error)
            return false
        }
    }
}
