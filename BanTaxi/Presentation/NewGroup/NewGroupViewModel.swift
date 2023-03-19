//
//  NewGroupViewModel.swift
//  BanTaxi
//
//  Created by 엄태양 on 2023/02/24.
//

import Foundation
import RxSwift
import RxRelay

struct NewGroupViewModel {
    let disposeBag = DisposeBag()
    
    let isLoading = BehaviorSubject(value: false)
    
    let intakeCountList = PublishRelay.just([2,3,4])
    let groupName = BehaviorRelay<String>(value: "")
    let time = BehaviorRelay<Date>(value: Date())
    let intakeIndex = BehaviorRelay(value: 0)
    let intake = BehaviorRelay<Int>(value: 2)
    let startingPoint = BehaviorRelay<AddressData?>(value: nil)
    let destinationPoint = BehaviorRelay<AddressData?>(value: nil)
    let saveButtonTap = PublishRelay<Void>()
    
    let requestResult = PublishRelay<RequestResult>()
    
    init(_ repo: GroupRepository = GroupRepository()) {
        
        saveButtonTap
            .map { _ in return true}
            .bind(to: isLoading)
            .disposed(by: disposeBag)
        
        requestResult
            .map { _ in return false }
            .bind(to: isLoading)
            .disposed(by: disposeBag)

        
        intakeIndex
            .withLatestFrom(intakeCountList) { $1[$0] }
            .bind(to: intake)
            .disposed(by: disposeBag)
        
        
        let newGroupData = Observable.combineLatest(groupName, time, intake, startingPoint, destinationPoint)
        
        saveButtonTap
            .withLatestFrom(newGroupData)
            .flatMapLatest(repo.createNewGroup(with:))
            .bind(to: requestResult)
            .disposed(by: disposeBag)
        
        requestResult.subscribe(onNext: { print($0 )}).disposed(by: disposeBag)
        
    }
}
