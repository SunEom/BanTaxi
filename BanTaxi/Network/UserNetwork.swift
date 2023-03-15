//
//  AuthNetwork.swift
//  BanTaxi
//
//  Created by 엄태양 on 2023/03/03.
//

import Foundation
import RxSwift
import FirebaseAuth
import FirebaseFirestore

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
                    } else {
                        let db = Firestore.firestore()
                        
                        if let uid = Auth.auth().currentUser?.uid {
                            db.collection("nickname").whereField("nickname", isEqualTo: nickname).getDocuments { snapshot, error in // 이미 사용중인 닉네임인지 확인
                                if let error = error {
                                    print(error.localizedDescription)
                                    return
                                } else {
                                    if snapshot != nil, snapshot!.count == 0 {
                                        db.collection("nickname").document(uid).setData(["nickname": nickname]) { error in
                                            if let error = error {
                                                print(error.localizedDescription)
                                                observer.onNext(RequestResult(isSuccess: false, msg: error.localizedDescription))
                                            } else {
                                                observer.onNext(RequestResult(isSuccess: true, msg: ""))
                                            }
                                        }
                                    } else {
                                        observer.onNext(RequestResult(isSuccess: false, msg: "이미 사용중인 닉네임입니다."))
                                    }
                                }
                            }
                        }
                        
                    }
                    
                    
                }
            } else {
                observer.onNext(RequestResult(isSuccess: false, msg: "업데이트 요청 생성 오류"))
            }
            return Disposables.create()
        }
    }
}
