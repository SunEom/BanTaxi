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
        
        return Observable<RequestResult>.create { observer in
            let id = "\(groupInfo.hostUid)\(Date().timeIntervalSince1970)" // document 이름으로 사용될 id
                db.collection("group").document(id).getDocument(completion: { snapshot, error in // 중복되는 id가 있는지 확인
                    if snapshot?.data() == nil {
                        db.collection("group").document(id).setData(groupInfo.getDict()) { error in
                                if error != nil {
                                    return observer.onNext(RequestResult(isSuccess: false, msg: "알 수 없는 오류가 발생했습니다."))
                                }
                                return observer.onNext(RequestResult(isSuccess: true, msg: "정상적으로 추가되었습니다."))
                            }
                    } else {
                        return observer.onNext(RequestResult(isSuccess: false, msg: "알 수 없는 오류가 발생했습니다."))
                    }
                })
                return Disposables.create()
        }
        
    }
}
