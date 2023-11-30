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
    func searchWithKeyword(with keyword: String) -> Observable<[AddressData]> {
        return network.requestAddressSearch(with: keyword)
    }
    
    func searchWithLocation(centerPoint: MTMapPoint) -> Observable<AddressData> {
        return Observable<AddressData>.create { observer in
            MTMapReverseGeoCoder.executeFindingAddress(for: centerPoint, openAPIKey: Bundle.main.Kakao_API_KEY) { success, shortAddress, error in
                observer.onNext(AddressData(roadAddress: shortAddress, jibunAddress: nil, latitude: centerPoint.mapPointGeo().latitude, longitude: centerPoint.mapPointGeo().longitude, placeName: nil))
            }
            
            return Disposables.create()
        }
    }
}
