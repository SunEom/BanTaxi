//
//  SearchViewModel.swift
//  BanTaxi
//
//  Created by 엄태양 on 2023/02/27.
//

import Foundation
import RxSwift
import RxRelay

struct SearchViewModel {
    let disposeBag = DisposeBag()
    let keyword = PublishSubject<String>()
    let titleSearchResult = PublishSubject<[GroupInfo]>()
    let titleSearchButtonTap = PublishRelay<Void>()
    
    init(_ repo: GroupRepository = GroupRepository()) {
        titleSearchButtonTap
            .withLatestFrom(keyword)
            .flatMapLatest(repo.fetchGroupsByKeyword(with:))
            .bind(to: titleSearchResult)
            .disposed(by: disposeBag)
    }
}
