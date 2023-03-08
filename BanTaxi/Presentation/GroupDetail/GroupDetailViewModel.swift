//
//  GroupDetailViewModel.swift
//  BanTaxi
//
//  Created by 엄태양 on 2023/03/06.
//

import Foundation
import RxSwift
import RxRelay

struct GroupDetailViewModel {
    let disposeBag = DisposeBag()
    let groupInfo: GroupInfo
    let isMine: Observable<Bool>
    let deleteRequest = PublishSubject<Void>()
    let deleteRequestResult = PublishSubject<RequestResult>()
    
    init(_ repo: GroupRepository = GroupRepository(), with groupInfo: GroupInfo) {
        self.groupInfo = groupInfo
        print(groupInfo)
        
        isMine = UserManager.getInstance()
            .map{ userData in
                if userData == nil {
                    return false
                } else {
                    if userData!.uid == groupInfo.hostUid {
                        return true
                    } else {
                        return false
                    }
                }
            }
        
        deleteRequest
            .flatMapLatest{ repo.deleteGroup(groupInfo) }
            .bind(to: deleteRequestResult)
            .disposed(by: disposeBag)
        
    }
}
