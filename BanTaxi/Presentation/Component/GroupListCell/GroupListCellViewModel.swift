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
    
    init(_ groupInfo: GroupInfo) {
        self.groupInfo = groupInfo
    }
}
