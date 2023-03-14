//
//  AuthNetwork.swift
//  BanTaxi
//
//  Created by 엄태양 on 2023/03/03.
//

import Foundation
import RxSwift
import FirebaseAuth

struct UserNetwork {
    func logoutFB() -> Bool {
        do {
            try Auth.auth().signOut()
            return true
        } catch (let error) {
            print(error)
            return false
        }
    }
    
    func updateNicknameFB(nickname: String) -> Observable<RequestResult>{
        return Observable.create { observer in
            if let request = Auth.auth().currentUser?.createProfileChangeRequest() {
                request.displayName = nickname
                request.commitChanges { error in
                    if let error = error {
                        print(error.localizedDescription)
                        observer.onNext(RequestResult(isSuccess: false, msg: error.localizedDescription))
                    }
                    
                    observer.onNext(RequestResult(isSuccess: true, msg: "닉네임 수정 성공"))
                }
            } else {
                observer.onNext(RequestResult(isSuccess: false, msg: "업데이트 요청 생성 오류"))
            }
            return Disposables.create()
        }
    }
}
