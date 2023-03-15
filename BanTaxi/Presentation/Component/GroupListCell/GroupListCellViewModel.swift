//
//  GroupListCellViewModel.swift
//  BanTaxi
//
//  Created by 엄태양 on 2023/03/06.
//

import Foundation
import RxSwift
import RxRelay

struct GroupListCellViewModel {
    let disposeBag = DisposeBag()
    let groupInfo: GroupInfo
    let available : Observable<Bool>
    
    init(_ groupInfo: GroupInfo) {
        self.groupInfo = groupInfo
        self.available = Observable.just(groupInfo.time > 1.days.earlier)
    }
}
