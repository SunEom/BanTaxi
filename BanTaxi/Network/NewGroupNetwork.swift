//
//  NewGroupNetwork.swift
//  BanTaxi
//
//  Created by 엄태양 on 2023/02/28.
//

import Foundation
import RxSwift
import FirebaseFirestore
import FirebaseAuth

struct NewGroupNetwork {
    
    let db = Firestore.firestore()
    
    func createNewGroupFB(with groupInfo: GroupInfo) -> Observable<RequestResult> {
        if Auth.auth().currentUser != nil {
            return Observable<RequestResult>.create { observer in
                    let id = "\(Auth.auth().currentUser!.uid)\(Date().timeIntervalSince1970)"
                    db.collection("group").document(id).getDocument(completion: { snapshot, error in
                        if snapshot?.data() == nil {
                            var requestData = groupInfo.getDict()
                            requestData["hostUid"] = Auth.auth().currentUser!.uid
                            db.collection("group").document(id).setData(requestData) { error in
                                    if error != nil {
                                        return observer.onNext(RequestResult(isSuccess: false, msg: "알 수 없는 오류가 발생했습니다."))
                                    }
                                    return observer.onNext(RequestResult(isSuccess: true, msg: "정상적으로 추가되었습니다."))
                                }
                        }
                    })
                    return Disposables.create()
            }
        } else {
            return Observable.just(RequestResult(isSuccess: false, msg: "로그인 오류"))
        }
    }
}
