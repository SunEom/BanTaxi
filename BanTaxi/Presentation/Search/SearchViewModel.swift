//
//  SearchViewModel.swift
//  BanTaxi
//
//  Created by 엄태양 on 2023/02/27.
//

import Foundation
import RxSwift
import RxCocoa

enum SearchMode {
    case groupName
    case location
}

enum LocationSearchType {
    case starting
    case destination
}

struct SearchViewModel {
    private let disposeBag = DisposeBag()
    private let repository: GroupRepository
    
    struct Input {
        let keyword: Driver<String>
        let address: Driver<AddressData?>
        let modeTrigger: Driver<SearchMode>
        let groupNameSearchTrigger: Driver<Void>
        let locationSearchTrigger: Driver<LocationSearchType>
        let selectGroupName: Driver<IndexPath>
        let selectLocation: Driver<IndexPath>
    }
    
    struct Output {
        let loading: Driver<Bool>
        let titleSearchList: Driver<[GroupInfo]>
        let locationSearchList: Driver<[GroupInfo]>
        let mode: Driver<SearchMode>
        let selectedGroup: Driver<GroupInfo>
    }
    
    init(_ repo: GroupRepository = GroupRepository()) {
        self.repository = repo
    }
    
    func transform(input: Input) -> Output {
        let loading = PublishSubject<Bool>()
        
        let mode = BehaviorSubject<SearchMode>(value: .groupName)
        input.modeTrigger.asObservable().bind(to: mode).disposed(by: disposeBag)
        
        let titleSearchList = input.groupNameSearchTrigger
            .do(onNext: { loading.onNext(true)} )
            .withLatestFrom(input.keyword)
            .flatMapLatest { name in
                repository.fetchGroupsByKeyword(with: name)
                    .do(onNext: { _ in loading.onNext(false)} )
                    .asDriver(onErrorJustReturn: [])
            }
        
        let locationSearchList = input.locationSearchTrigger
            .do(onNext: { _ in loading.onNext(true)} )
            .withLatestFrom(input.address) { mode, address in (mode, address)}
            .flatMapLatest { mode, address in
                guard let address = address else { return Driver.just([GroupInfo]()) }
                if mode == .starting {
                    return repository.fetchWithStartPoint(from: address)
                        .do(onNext: { _ in loading.onNext(false)} )
                        .asDriver(onErrorJustReturn: [])
                } else {
                    return repository.fetchWithDestination(from: address)
                        .do(onNext: { _ in loading.onNext(false)} )
                        .asDriver(onErrorJustReturn: [])
                }
            }
        
        let selectedInGroupName = input.selectGroupName
            .withLatestFrom(titleSearchList) { indexPath, list in list[indexPath.row] }
            
        let selectedInLocation = input.selectLocation
            .withLatestFrom(locationSearchList) { indexPath, list in list[indexPath.row] }
        
        let selectedGroup = Driver.merge(selectedInGroupName, selectedInLocation)
        
        return Output(loading: loading.asDriver(onErrorJustReturn: false), titleSearchList: titleSearchList, locationSearchList: locationSearchList, mode: mode.asDriver(onErrorJustReturn: .groupName), selectedGroup: selectedGroup)
    }
}
