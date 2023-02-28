//
//  NewGroupRepository.swift
//  BanTaxi
//
//  Created by 엄태양 on 2023/02/28.
//

import Foundation
import RxSwift

struct NewGroupRepository {
    
    private let network = NewGroupNetwork()
    
    func createNewGroup(with data: (name: String, time: Date, intake: Int, start: AddressData?, destination: AddressData?)) -> Observable<RequestResult> {
        if let validResult = vaildateData(data) {
            return Observable.just(validResult)
        }
        
        return network.createNewGroupFB(with: GroupInfo(name: data.name, time: data.time, intake: data.intake, start: data.start!, destination: data.destination!))
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
}
