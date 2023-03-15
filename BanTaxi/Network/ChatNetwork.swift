//
//  ChatNetwork.swift
//  BanTaxi
//
//  Created by 엄태양 on 2023/03/15.
//

import Foundation
import FirebaseFirestore
import RxSwift

struct ChatNetwork {
    let db = Firestore.firestore()
    
    func createNewChatFB(chatData: Chat) {
        db.collection("chat").addDocument(data: chatData.getDict()) { error in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    func setChatObserver(groupID: String) -> Observable<[Chat]> {
        return Observable<[Chat]>.create { observer in
            db.collection("chat").whereField("groupID", isEqualTo: groupID).addSnapshotListener { documentSnapshot, error in
                guard let snapshot = documentSnapshot else {
                    print("Error fetching document: \(error!)")
                    return
                }
                
                var list = [Chat]()
                for document in snapshot.documents {
                    list.append(Chat(data: document.data()))
                }
                list.sort { $0.date < $1.date }
                observer.onNext(list)
            }
            return Disposables.create()
        }
    
    }
}
