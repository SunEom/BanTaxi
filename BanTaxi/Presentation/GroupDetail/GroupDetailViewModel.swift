//
//  GroupDetailViewModel.swift
//  BanTaxi
//
//  Created by 엄태양 on 2023/03/06.
//

import Foundation
import RxSwift
import RxCocoa

struct GroupDetailViewModel {
    private let disposeBag = DisposeBag()
    private let repository: GroupRepository
    private let groupInfo: BehaviorSubject<GroupInfo>
    
    struct Input {
        let fetchTrigger: Driver<Void>
        let deleteTrigger: Driver<Void>
        let joinTrigger: Driver<Void>
        let exitTrigger: Driver<Void>
    }
    
    struct Output {
        let loading: Driver<Bool>
        let group: Observable<GroupInfo>
        let available: Driver<Bool>
        let isMine: Driver<Bool>
        let alreadyJoin: Driver<Bool>
        let result: Driver<RequestResult>
    }
    
    init(_ repo: GroupRepository = GroupRepository(), with groupInfo: GroupInfo) {
        self.repository = repo
        self.groupInfo = BehaviorSubject(value: groupInfo)
        
//        //MARK: - 로딩 설정
//        
//
//        Observable.of(fetchRequest, deleteRequest, joinRequest, exitRequest).merge()
//            .map { _ in true }
//            .bind(to: isLoading)
//            .disposed(by: disposeBag)
//        
//        self.groupInfo
//            .map { _ in false }
//            .bind(to: isLoading)
//            .disposed(by: disposeBag)
//        
//        Observable.of( exitRequestResult).merge()
//            .map { _ in false }
//            .bind(to: isLoading)
//            .disposed(by: disposeBag)
//        
//        //MARK: - 그룹 정보 확인
//        
//        self.groupInfo.withLatestFrom(UserManager.getInstance()){ groupInfo, userData in
//            return (groupInfo, userData)
//        }
//        .map{ (groupInfo, userData) in
//            if userData == nil {
//                return false
//            } else {
//                return userData!.uid == groupInfo.hostUid
//            }
//        }
//        .bind(to: isMine)
//        .disposed(by: disposeBag)
//        
//        self.groupInfo.withLatestFrom(UserManager.getInstance()){ groupInfo, userData in
//            return (groupInfo, userData)
//        }
//        .map{ (groupInfo, userData) in
//            if userData == nil {
//                return false
//            } else {
//                return groupInfo.participants.contains(userData!.uid)
//            }
//        }
//        .bind(to: alreadyJoin)
//        .disposed(by: disposeBag)
//        
//        //MARK: - 그룹 삭제
//        
//        deleteRequest
//            .flatMapLatest{ repo.deleteGroup(groupInfo) }
//            .bind(to: deleteRequestResult)
//            .disposed(by: disposeBag)
//        
//        //MARK: - 그룹 상세정보 가져오기
//        
//        fetchRequest
//            .flatMapLatest { repo.fetchDetail(id: groupInfo.documentID) }
//            .bind(to: self.groupInfo)
//            .disposed(by: disposeBag)
//        
//        joinRequestResult
//            .map { _ in Void() }
//            .bind(to: fetchRequest )
//            .disposed(by: disposeBag)
//        
//        exitRequestResult
//            .map { _ in Void() }
//            .bind(to: fetchRequest)
//            .disposed(by: disposeBag)
//        
//        //MARK: - 그룹 참여
//        joinRequest
//            .flatMapLatest { repo.joinGroup(groupID: groupInfo.documentID) }
//            .bind(to: joinRequestResult)
//            .disposed(by: disposeBag)
//        
//        //MARK: - 그룹 나가기
//        exitRequest
//            .flatMapLatest { repo.exitGroup(groupID: groupInfo.documentID) }
//            .bind(to: exitRequestResult)
//            .disposed(by: disposeBag)
    }
    
    func transform(input: Input) -> Output {
        let loading = PublishSubject<Bool>()
        
        let update = PublishSubject<Void>()
        Observable.merge(update, input.fetchTrigger.asObservable())
            .withLatestFrom(groupInfo)
            .do(onNext:  { _ in loading.onNext(true)})
            .flatMapLatest { groupInfo in
                repository.fetchDetail(id: groupInfo.documentID)
                    .do(onNext:  { _ in loading.onNext(false)})
            }
            .bind(to: groupInfo)
            .disposed(by: disposeBag)
            
        
        let available = groupInfo.map { $0.time <= .now }
            .asDriver(onErrorJustReturn: false)
        
        let isMine = groupInfo.withLatestFrom(UserManager.getInstance()) { groupInfo, user in groupInfo.hostUid == user!.uid }.asDriver(onErrorJustReturn: false)
        
        let alreadyJoin = groupInfo.withLatestFrom(UserManager.getInstance()){ groupInfo, user in groupInfo.participants.contains(user!.uid) }.asDriver(onErrorJustReturn: false)
        
        let result = input.deleteTrigger
            .asObservable()
            .withLatestFrom(groupInfo)
            .flatMapLatest { group in
                repository.deleteGroup(group)
            }
            .asDriver(onErrorJustReturn: RequestResult(isSuccess: false, msg: ""))
        
        input.exitTrigger
            .asObservable()
            .do(onNext: { _ in loading.onNext(true)})
            .withLatestFrom(groupInfo)
            .flatMapLatest { group in
                repository.exitGroup(groupID: group.documentID)
            }
            .map { _ in () }
            .bind(to: update)
            .disposed(by: disposeBag)
        
        input.joinTrigger
            .asObservable()
            .do(onNext: { _ in loading.onNext(true)})
            .withLatestFrom(groupInfo)
            .flatMapLatest { group in
                repository.joinGroup(groupID: group.documentID)
            }
            .map { _ in () }
            .bind(to: update)
            .disposed(by: disposeBag)
            
        
        return Output(loading: loading.asDriver(onErrorJustReturn: false), group: groupInfo.asObservable(), available: available, isMine: isMine, alreadyJoin: alreadyJoin, result: result)
    }
}
