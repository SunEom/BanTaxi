//
//  MyGroupViewModel.swift
//  BanTaxi
//
//  Created by 엄태양 on 2023/03/06.
//

import Foundation
import RxSwift
import RxRelay

struct MyGroupViewModel {
    let disposeBag = DisposeBag()
    
    let list : Observable<[GroupInfo]>
    
    
    init(_ repo: GroupRepository = GroupRepository()) {
        list = repo.fetchMyGroup()
    }
}
