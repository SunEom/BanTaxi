//
//  GroupDetailViewModel.swift
//  BanTaxi
//
//  Created by 엄태양 on 2023/03/06.
//

import Foundation
import RxSwift
import RxRelay

struct GroupDetailViewModel {
    let disposeBag = DisposeBag()
    let groupInfo: BehaviorSubject<GroupInfo>!
    let groupID: String
    
    let isLoading = BehaviorSubject(value: true)
    let fetchRequest = PublishSubject<Void>()
    
    let isMine = PublishSubject<Bool>()
    let deleteRequest = PublishSubject<Void>()
    let deleteRequestResult = PublishSubject<RequestResult>()
    let alreadyJoin = PublishSubject<Bool>()
    
    let joinRequest = PublishSubject<Void>()
    let joinRequestResult = PublishSubject<RequestResult>()
    
    let exitRequest = PublishSubject<Void>()
    let exitRequestResult = PublishSubject<RequestResult>()
    
    init(_ repo: GroupRepository = GroupRepository(), with groupInfo: GroupInfo) {
        self.groupInfo = BehaviorSubject(value: groupInfo)
        self.groupID = groupInfo.documentID
        
        //MARK: - 로딩 설정
        

        Observable.of(fetchRequest, deleteRequest, joinRequest, exitRequest).merge()
            .map { _ in true }
            .bind(to: isLoading)
            .disposed(by: disposeBag)
        
        self.groupInfo
            .map { _ in false }
            .bind(to: isLoading)
            .disposed(by: disposeBag)
        
        Observable.of( exitRequestResult).merge()
            .map { _ in false }
            .bind(to: isLoading)
            .disposed(by: disposeBag)
        
        //MARK: - 그룹 정보 확인
        
        self.groupInfo.withLatestFrom(UserManager.getInstance()){ groupInfo, userData in
            return (groupInfo, userData)
        }
        .map{ (groupInfo, userData) in
            if userData == nil {
                return false
            } else {
                return userData!.uid == groupInfo.hostUid
            }
        }
        .bind(to: isMine)
        .disposed(by: disposeBag)
        
        self.groupInfo.withLatestFrom(UserManager.getInstance()){ groupInfo, userData in
            return (groupInfo, userData)
        }
        .map{ (groupInfo, userData) in
            if userData == nil {
                return false
            } else {
                return groupInfo.participants.contains(userData!.uid)
            }
        }
        .bind(to: alreadyJoin)
        .disposed(by: disposeBag)
        
        //MARK: - 그룹 삭제
        
        deleteRequest
            .flatMapLatest{ repo.deleteGroup(groupInfo) }
            .bind(to: deleteRequestResult)
            .disposed(by: disposeBag)
        
        //MARK: - 그룹 상세정보 가져오기
        
        fetchRequest
            .flatMapLatest { repo.fetchDetail(id: groupInfo.documentID) }
            .bind(to: self.groupInfo)
            .disposed(by: disposeBag)
        
        joinRequestResult
            .map { _ in Void() }
            .bind(to: fetchRequest )
            .disposed(by: disposeBag)
        
        exitRequestResult
            .map { _ in Void() }
            .bind(to: fetchRequest)
            .disposed(by: disposeBag)
        
        //MARK: - 그룹 참여
        joinRequest
            .flatMapLatest { repo.joinGroup(groupID: groupInfo.documentID) }
            .bind(to: joinRequestResult)
            .disposed(by: disposeBag)
        
        //MARK: - 그룹 나가기
        exitRequest
            .flatMapLatest { repo.exitGroup(groupID: groupInfo.documentID) }
            .bind(to: exitRequestResult)
            .disposed(by: disposeBag)
    }
}
