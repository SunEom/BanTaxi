//
//  MainViewModel.swift
//  BanTaxi
//
//  Created by 엄태양 on 2023/02/20.
//

import Foundation
import RxSwift
import RxRelay

struct LocationSelectViewModel {
    let disposeBag = DisposeBag()
    let mapCenterPoint = PublishRelay<MTMapPoint>()
    let selectedPoint = PublishSubject<AddressSearchResult>()
    
    init() {
        
        // 지도 이동시 중앙 지점 주소 확인
        mapCenterPoint
            .flatMapLatest { centerPoint in
                return Observable<AddressSearchResult>.create { observer in
                    
                    MTMapReverseGeoCoder.executeFindingAddress(for: centerPoint, openAPIKey: Bundle.main.Kakao_API_KEY) { success, shortAddress, error in
                        observer.onNext(AddressSearchResult(postCode: "", roadAddress: shortAddress, jibunAddress: nil, latitude: centerPoint.mapPointGeo().latitude, longitude: centerPoint.mapPointGeo().longitude))
                    }
                    
                    return Disposables.create()
                }
            }
            .bind(to: selectedPoint)
            .disposed(by: disposeBag)
            
        
        
            
    }

}
