//
//  AddressSearchViewModel.swift
//  BanTaxi
//
//  Created by 엄태양 on 2023/02/25.
//

import Foundation
import RxSwift
import RxCocoa

struct AddressSearchViewModel {
    private let disposeBag = DisposeBag()
    private let repository: AddressRepository
    private let select: BehaviorSubject<AddressData?>
    private let mode: LocationSettingMode
    
    struct Input {
        let keyword: Driver<String>
        let searchTrigger: Driver<Void>
        let saveTrigger: Driver<IndexPath>
    }
    
    struct Output {
        let loading: Driver<Bool>
        let result: Driver<[AddressData]>
    }
    
    init(mode: LocationSettingMode, select: BehaviorSubject<AddressData?>,_ repo: AddressRepository = AddressRepository()) {
        self.repository = repo
        self.mode = mode
        self.select = select
    }
    
    func transform(input: Input) -> Output {
        let loading = PublishSubject<Bool>()
        
        let result = input.searchTrigger
            .do(onNext: { loading.onNext(true)} )
            .withLatestFrom(input.keyword)
            .flatMapLatest { keyword in
                repository.searchWithKeyword(with: keyword)
                    .do(onNext: { _ in loading.onNext(false)} )
                    .asDriver(onErrorJustReturn: [])
            }
        
        input.saveTrigger
            .withLatestFrom(result) { indexPath, list in list[indexPath.row] }
            .asObservable()
            .bind(to: select)
            .disposed(by: disposeBag)
        
        return Output(loading: loading.asDriver(onErrorJustReturn: false), result: result)
    }
}
