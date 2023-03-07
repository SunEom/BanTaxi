//
//  MapViewModel.swift
//  BanTaxi
//
//  Created by 엄태양 on 2023/03/07.
//

import Foundation
import RxSwift
import RxRelay

struct MapViewModel {
    let disposeBag = DisposeBag()
    let start: AddressData
    let destination: AddressData
    
    init(start: AddressData, destination: AddressData) {
        self.start = start
        self.destination = destination
    }
}
