//
//  AddressRepository.swift
//  BanTaxi
//
//  Created by 엄태양 on 2023/02/27.
//

import Foundation
import RxSwift

struct AddressRepository {
    let network = AddressNetwork()
    func searchWithKeyword(with keyword: String) -> Observable<[AddressData]?> {
        return network.requestAddressSearch(with: keyword)
    }
}
