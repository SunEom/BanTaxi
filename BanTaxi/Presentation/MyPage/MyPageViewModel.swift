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
    let logoutResult = PublishRelay<RequestResult>()
    
    init(_ repo: UserRepository = UserRepository()) {
        
        logoutButtonTap
            .flatMapLatest(repo.logout)
            .bind(to: logoutResult)
            .disposed(by: disposeBag)
            
    }
}
