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
    
    let isLoading = BehaviorSubject(value: true)
    
    let list = PublishSubject<[GroupInfo]>()
    let fetchRequest = PublishSubject<Void>()
    
    init(_ repo: GroupRepository = GroupRepository()) {
        fetchRequest
            .flatMapLatest(repo.fetchMyGroup)
            .bind(to: list)
            .disposed(by: disposeBag)
        
        //MARK: - 로딩 설정
        
        fetchRequest
            .map { _ in return true}
            .bind(to: isLoading)
            .disposed(by: disposeBag)
        
        list
            .map { _ in return false}
            .bind(to: isLoading)
            .disposed(by: disposeBag)
    }
}
