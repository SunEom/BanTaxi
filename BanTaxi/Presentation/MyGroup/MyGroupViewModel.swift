//
//  MyGroupViewModel.swift
//  BanTaxi
//
//  Created by 엄태양 on 2023/03/06.
//

import Foundation
import RxSwift
import RxCocoa

struct MyGroupViewModel {
    private let disposeBag = DisposeBag()
    private let repository: GroupRepository
    
    struct Input {
        let trigger: Driver<Void>
        let select: Driver<IndexPath>
    }
    
    struct Output {
        let loading: Driver<Bool>
        let groups: Driver<[GroupInfo]>
        let selectedGroup: Driver<GroupInfo>
    }
    
    init(_ repo: GroupRepository = GroupRepository()) {
        self.repository = repo
    }
    
    func transform(input: Input) -> Output {
        let loading = PublishSubject<Bool>()
        
        let groups = input.trigger
            .do(onNext: { _ in loading.onNext(true)})
            .flatMapLatest {
                repository.fetchMyGroup()
                    .do(onNext: { _ in loading.onNext(false)})
                    .asDriver(onErrorJustReturn: [])
            }
        
        let selectedGroup = input.select
            .withLatestFrom(groups) { indexPath, list in list[indexPath.row] }
        
        return Output(loading: loading.asDriver(onErrorJustReturn: false), groups: groups, selectedGroup: selectedGroup)
        
    }
}
