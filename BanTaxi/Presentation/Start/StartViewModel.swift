//
//  StartViewModel.swift
//  BanTaxi
//
//  Created by 엄태양 on 2023/03/02.
//

import Foundation
import RxSwift
import RxRelay

struct StartViewModel {
    let diseposBag = DisposeBag()
    let loginRequest = PublishSubject<Void>()
    let loginCheckFinished = PublishSubject<Void>()
    
    init(_ repo: UserRepository = UserRepository()) {
        loginRequest
            .map(repo.localAutoLogin)
            .map(UserManager.login(userData:))
            .bind(to: loginCheckFinished)
            .disposed(by: diseposBag)
    }
}
