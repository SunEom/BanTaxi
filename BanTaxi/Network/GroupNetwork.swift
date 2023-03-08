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

struct GroupNetwork {
    
    let db = Firestore.firestore()
    
    func createNewGroupFB(with groupInfo: GroupInfo) -> Observable<RequestResult> {
        
        return Observable<RequestResult>.create { observer in
            let id = "\(groupInfo.hostUid)\(Date().timeIntervalSince1970)" // document 이름으로 사용될 id
                db.collection("group").document(id).getDocument(completion: { snapshot, error in // 중복되는 id가 있는지 확인
                    if snapshot?.data() == nil {
                        var data = groupInfo
                        data.documentID = id
                        db.collection("group").document(id).setData(data.getDict()) { error in
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
    
    func fetchMyGroupsFB(with uid: String) -> Observable<[GroupInfo]> {
        return Observable.create { observer in
            db.collection("group").whereField("hostUid", isEqualTo: uid)
                .getDocuments { snapshot, err in
                    if let err = err {
                        print("Error getting documents: \(err)")
                    } else {
                        var list = [GroupInfo]()
                        for document in snapshot!.documents {
                            list.append(GroupInfo(data: document.data()))
                        }
                        list.sort { $0.time > $1.time}
                        observer.onNext(list)
                    }
                }
            return Disposables.create()
        }
        
    }
    
    func fetchAllGroupsFB() -> Observable<[GroupInfo]> {
        return Observable.create { observer in
            db.collection("group")
                .getDocuments { snapshot, err in
                    if let err = err {
                        print("Error getting documents: \(err)")
                    } else {
                        var list = [GroupInfo]()
                        for document in snapshot!.documents {
                            list.append(GroupInfo(data: document.data()))
                        }
                        list.sort { $0.time > $1.time}
                        observer.onNext(list)
                    }
                }
            return Disposables.create()
        }
        
    }
    
    
    func deleteGroupFB(_ groupInfo: GroupInfo) -> Observable<RequestResult> {
        return Observable.create { observer in
            db.collection("group").document(groupInfo.documentID).delete() { error in
                if let error = error {
                    observer.onNext(RequestResult(isSuccess: false, msg: error.localizedDescription))
                } else {
                    observer.onNext(RequestResult(isSuccess: true, msg: "정상적으로 삭제되었습니다."))
                }
            }
            return Disposables.create()
        }
    }
    
    func fetchDetailFB(id: String) -> Observable<GroupInfo> {
        return Observable.create { observer in
            db.collection("group").document(id).getDocument { snapshot, error in
                if let error = error {
                    print(error)
                } else {
                    if let data = snapshot?.data() {
                        observer.onNext(GroupInfo(data: data))
                    } else {
                        print("Error...")
                    }
                    
                }
            }
            return Disposables.create()
        }
    }
    
    func joinGroupFB(groupID: String) -> Observable<RequestResult> {
        return Observable<RequestResult>.create { observer in
            
            db.collection("group").document(groupID).getDocument { snapshot, error in
                if let error = error {
                    print(error)
                } else {
                    if let data = snapshot?.data() {
                        let groupInfo = GroupInfo(data: data)
                        if let uid = Auth.auth().currentUser?.uid {
                            if groupInfo.participants.contains(uid) {
                                observer.onNext(RequestResult(isSuccess: false, msg: "이미 참여한 그룹입니다."))
                            } else {
                                db.collection("group").document(groupInfo.documentID).updateData(["participants" : groupInfo.participants + [uid], "participantsCount": groupInfo.participantsCount+1]) { error in
                                    if let error = error {
                                        print(error)
                                        observer.onNext(RequestResult(isSuccess: false, msg: error.localizedDescription))
                                    } else {
                                        observer.onNext(RequestResult(isSuccess: true, msg: "정상적으로 참여되었습니다."))
                                    }
                                }
                            }
                            
                        }
                        
                    } else {
                        print("Error...")
                    }
                    
                }
            }
            
            return Disposables.create()
        }
    }
    
    func exitGroupFB(groupID: String) -> Observable<RequestResult> {
        return Observable.create { observer in
            
            db.collection("group").document(groupID).getDocument { snapshot, error in
                if let error = error {
                    print(error)
                } else {
                    if let data = snapshot?.data() {
                        let groupInfo = GroupInfo(data: data)
                        if let uid = Auth.auth().currentUser?.uid {
                            if !groupInfo.participants.contains(uid) {
                                observer.onNext(RequestResult(isSuccess: false, msg: "참여 중인 그룹이 아닙니다."))
                            } else {
                                db.collection("group").document(groupInfo.documentID).updateData(["participants" : groupInfo.participants.filter { $0 != uid }, "participantsCount": groupInfo.participantsCount-1]) { error in
                                    if let error = error {
                                        print(error)
                                        observer.onNext(RequestResult(isSuccess: false, msg: error.localizedDescription))
                                    } else {
                                        observer.onNext(RequestResult(isSuccess: true, msg: "정상적으로 참여되었습니다."))
                                    }
                                }
                            }
                            
                        }
                        
                    } else {
                        print("Error...")
                    }
                    
                }
            }
            
            return Disposables.create()
        }
    }
    
}
