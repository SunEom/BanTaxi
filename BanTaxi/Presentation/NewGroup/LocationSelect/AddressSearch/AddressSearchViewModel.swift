//
//  AddressSearchViewModel.swift
//  BanTaxi
//
//  Created by 엄태양 on 2023/02/25.
//

import Foundation
import RxRelay
import RxSwift

struct SearchResult { // 임시 데이터를 위한 구조체
    let postCode: String
    let roadAddress: String
    let jibunAddress: String
}

struct AddressSearchViewModel {
    let diseposBag = DisposeBag()
    let searchResults = PublishRelay<[SearchResult]>.just(
        [
            SearchResult(postCode: "124252", roadAddress: "서울시 강서구 공항대로55길 19", jibunAddress: "등촌동 714"),
            SearchResult(postCode: "07536", roadAddress: "서울시 강서구 양천로69길 58", jibunAddress: "염창동 292")
        ]
    )
}
