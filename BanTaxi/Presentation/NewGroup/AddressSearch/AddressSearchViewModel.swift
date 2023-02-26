//
//  AddressSearchViewModel.swift
//  BanTaxi
//
//  Created by 엄태양 on 2023/02/25.
//

import Foundation
import RxRelay
import RxSwift

struct AddressSearchViewModel {
    let diseposBag = DisposeBag()
    let searchResults = PublishRelay<[AddressData]>.just(
        [
            AddressData(postCode: "124252", roadAddress: "서울 양천구 목동 956", jibunAddress: "서울 양천구 목동 956", latitude: 37.54648392996183, longitude: 126.86734020702669),
            AddressData(postCode: "07536", roadAddress: "서울 마포구 상암동 1731-9", jibunAddress: "서울 마포구 상암동 1731-9", latitude: 37.57325329797397, longitude: 126.88743285829601)
        ]
    )
}
