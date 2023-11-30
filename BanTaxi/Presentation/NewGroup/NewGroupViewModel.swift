//
//  NewGroupViewModel.swift
//  BanTaxi
//
//  Created by 엄태양 on 2023/02/24.
//

import Foundation
import RxSwift
import RxCocoa

struct NewGroupViewModel {
    private let disposeBag = DisposeBag()
    private let repository: GroupRepository
    
    
    struct Input {
        let groupName: Driver<String>
        let time: Driver<Date>
        let intakeSelect: Driver<Int>
        let startingPoint: Driver<AddressData?>
        let destinationPoint: Driver<AddressData?>
        let saveTrigger: Driver<Void>
    }
    
    struct Output {
        let loading: Driver<Bool>
        let intakeCountList: Driver<[Int]>
        let result: Driver<RequestResult>
    }
    
    init(_ repo: GroupRepository = GroupRepository()) {
        self.repository = repo
    }
    
    func transform(input: Input) -> Output {
        let loading = PublishSubject<Bool>()
        
        let intakeCountList = Driver.just([2,3,4])
        let intake = BehaviorSubject(value: 2)
        input.intakeSelect
            .withLatestFrom(intakeCountList) { idx, list in list[idx] }
            .asObservable().bind(to: intake)
            .disposed(by: disposeBag)

        let result = input.saveTrigger
            .withLatestFrom(Driver.combineLatest(input.groupName, input.time, intake.asDriver(onErrorJustReturn: 2), input.startingPoint, input.destinationPoint))
            .flatMapLatest { groupName, time, intake, startingPoint, destination in
                repository.createNewGroup(with: (groupName, time, intake, startingPoint, destination))
                    .asDriver(onErrorJustReturn: RequestResult(isSuccess: false, msg: ""))
            }
        
        return Output(loading: loading.asDriver(onErrorJustReturn: false), intakeCountList: intakeCountList, result: result)
    }
}
