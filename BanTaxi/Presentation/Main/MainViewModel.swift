//
//  MainViewModel.swift
//  BanTaxi
//
//  Created by 엄태양 on 2023/02/20.
//

import Foundation
import RxSwift
import RxRelay

struct MainViewModel {
    let disposeBag = DisposeBag()
    let mapCenterPoint = PublishRelay<MTMapPoint>()
    let mapCenterAddress = PublishRelay<String>()
    
    init() {
        
        // 지도 이동시 중앙 지점 주소 확인
        mapCenterPoint
            .flatMapLatest { centerPoint in
                return Observable<String>.create { observer in
                    
                    MTMapReverseGeoCoder.executeFindingAddress(for: centerPoint, openAPIKey: Bundle.main.Kakao_API_KEY) { success, address, error in
                        observer.onNext(address ?? "")
                    }
                    
                    return Disposables.create()
                }
            }
            .bind(to: mapCenterAddress)
            .disposed(by: disposeBag)
        
        mapCenterAddress.subscribe(onNext: { print($0) })
        
            
    }

}
