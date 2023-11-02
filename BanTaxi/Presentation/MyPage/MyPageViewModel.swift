//
//  MyPageViewModel.swift
//  BanTaxi
//
//  Created by 엄태양 on 2023/03/03.
//

import Foundation
import RxSwift
import RxRelay

struct MyPageViewModel {
    let disposeBag = DisposeBag()
    let user = UserManager.getInstance()
    let logoutButtonTap = PublishRelay<Void>()
    
    init() {
        
        logoutButtonTap
            .subscribe(onNext: {
                UserManager.logout()
            })
            .disposed(by: disposeBag)
            
            
    }
}
