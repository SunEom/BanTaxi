//
//  AddressSearchCellViewModel.swift
//  BanTaxi
//
//  Created by 엄태양 on 2023/02/26.
//

import RxSwift
import RxRelay

struct AddressSearchViewCellViewModel {
    
    private let disposeBag = DisposeBag()
    let roadAddress: String?
    let jibunAddress: String?
    let placeName: String?
    
    init(addressSearchResult: AddressData) {
        roadAddress = addressSearchResult.roadAddress
        jibunAddress = addressSearchResult.jibunAddress
        placeName = addressSearchResult.placeName
    }
}
