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
    
    init(with groupInfo: GroupInfo) {
        self.groupInfo = groupInfo
    }
}
