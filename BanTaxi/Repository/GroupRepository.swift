//
//  NewGroupRepository.swift
//  BanTaxi
//
//  Created by 엄태양 on 2023/02/28.
//

import Foundation
import FirebaseAuth
import RxSwift

struct GroupRepository {
    
    private let network = GroupNetwork()
    
    func createNewGroup(with data: (name: String, time: Date, intake: Int, start: AddressData?, destination: AddressData?)) -> Observable<RequestResult> {
        if let validResult = vaildateData(data) {
            return Observable.just(validResult)
        }
        
        if let uid = Auth.auth().currentUser?.uid {
            return network.createNewGroupFB(with: GroupInfo(name: data.name, time: data.time, intake: data.intake, start: data.start!, destination: data.destination!,hostUid: uid))
        } else {
            return Observable.just(RequestResult(isSuccess: false, msg: "로그인 오류"))
        }
        
    }
    
    private func vaildateData(_ data: (name: String, time: Date, intake: Int, start: AddressData?, destination: AddressData?)) -> RequestResult? {
        if data.name == "" {
            return RequestResult(isSuccess: false, msg: "그룹명을 입력해주세요.")
        } else if data.start == nil {
            return RequestResult(isSuccess: false, msg: "시작점을 설정해주세요.")
        } else if data.destination == nil {
            return RequestResult(isSuccess: false, msg: "도착점을 설정해주세요.")
        }
        return nil
    }
    
    func fetchMyGroup() -> Observable<[GroupInfo]> {
        
        if let uid = Auth.auth().currentUser?.uid {
            return network.fetchMyGroupsFB(with: uid)
        } else {
            return Observable.just([])
        }
    }
    
    func fetchGroupsByKeyword(with keyword: String) -> Observable<[GroupInfo]> {
        return network.fetchAllGroupsFB()
            .map{ $0.filter { $0.name.contains(keyword) }}
    }
    
}
