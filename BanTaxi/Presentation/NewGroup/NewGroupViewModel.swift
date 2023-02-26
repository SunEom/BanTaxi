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
    let intakeCount = PublishRelay.just([2,3,4,5])
    let startingPoint = BehaviorRelay<AddressData?>(value: nil)
    let destinationPoint = BehaviorRelay<AddressData?>(value: nil)
}
