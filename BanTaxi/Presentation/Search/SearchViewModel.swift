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
    
    let isLoading = BehaviorSubject(value: false)
    
    let keyword = PublishSubject<String>()
    let titleSearchResult = PublishSubject<[GroupInfo]>()
    let titleSearchButtonTap = PublishRelay<Void>()
    
    let targetAddress = BehaviorRelay<AddressData?>(value: nil)
    let startPointSearchButtonTap = PublishRelay<Void>()
    let destinationSearchButtonTap = PublishRelay<Void>()
    let locationSearchResult = PublishSubject<[GroupInfo]>()
    
    init(_ repo: GroupRepository = GroupRepository()) {
        
        Observable.of(titleSearchButtonTap, startPointSearchButtonTap, destinationSearchButtonTap).merge()
            .map { _ in return true }
            .bind(to: isLoading)
            .disposed(by: disposeBag)
        
        Observable.of(titleSearchResult, locationSearchResult).merge()
            .map { _ in return false }
            .bind(to: isLoading)
            .disposed(by: disposeBag)
        
        titleSearchButtonTap
            .withLatestFrom(keyword)
            .flatMapLatest(repo.fetchGroupsByKeyword(with:))
            .bind(to: titleSearchResult)
            .disposed(by: disposeBag)

        startPointSearchButtonTap
            .withLatestFrom(targetAddress)
            .filter{ $0 != nil}
            .flatMapLatest{repo.fetchWithStartPoint(from: $0!)}
            .bind(to: locationSearchResult)
            .disposed(by: disposeBag)
            
        
        destinationSearchButtonTap
            .withLatestFrom(targetAddress)
            .filter{ $0 != nil}
            .flatMapLatest{repo.fetchWithDestination(from: $0!)}
            .bind(to: locationSearchResult)
            .disposed(by: disposeBag)
        
    }
}
