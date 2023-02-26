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
    let searchResults = PublishRelay<[AddressSearchResult]>.just(
        [
            AddressSearchResult(postCode: "124252", roadAddress: "서울시 강서구 공항대로55길 19", jibunAddress: "등촌동 714", latitude: nil, longitude: nil),
            AddressSearchResult(postCode: "07536", roadAddress: "서울시 강서구 양천로69길 58", jibunAddress: "염창동 292", latitude: nil, longitude: nil)
        ]
    )
}
