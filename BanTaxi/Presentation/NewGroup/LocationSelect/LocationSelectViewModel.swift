//
//  MainViewModel.swift
//  BanTaxi
//
//  Created by 엄태양 on 2023/02/20.
//

import Foundation
import RxSwift
import RxCocoa
import CoreLocation

struct LocationSelectViewModel {
    private let disposeBag = DisposeBag()
    private let repository: AddressRepository
    private let locationManager = CLLocationManager()
    private let mode: LocationSettingMode
    private let select: BehaviorSubject<AddressData?>
    
    struct Input {
        let initLocationTrigger: Driver<Void>
        let centerTrigger: Driver<MTMapPoint>
        let saveTrigger: Driver<Void>
    }
    
    struct Output {
        let initLocation: Driver<MTMapPoint>
        let address: Driver<AddressData>
        let mode: Driver<LocationSettingMode>
    }
    
    init(mode: LocationSettingMode, select: BehaviorSubject<AddressData?>, _ repo: AddressRepository = AddressRepository()) {
        self.repository = repo
        self.mode = mode
        self.select = select
    }
    
    func transform(input: Input) -> Output {
        let nowLocation = PublishSubject<MTMapPoint>()
        
        input.centerTrigger.asObservable().bind(to: nowLocation).disposed(by: disposeBag)
        
        let initLocation = input.initLocationTrigger
            .map {
                if let lat = self.locationManager.location?.coordinate.latitude, let logt = self.locationManager.location?.coordinate.longitude {
                    return MTMapPoint(geoCoord: MTMapPointGeo(latitude: lat, longitude: logt))!
                } else {
                    return MTMapPoint(geoCoord: MTMapPointGeo(latitude: 37.57861, longitude: 126.9768))!
                }
            }
            .do(onNext: { nowLocation.onNext($0)} )
        
        
        let address = nowLocation
            .flatMapLatest { centerPoint in
                repository.searchWithLocation(centerPoint: centerPoint)
            }.asDriver(onErrorJustReturn: AddressData(roadAddress: nil, jibunAddress: nil, latitude: nil, longitude: nil, placeName: nil))
        
        input.saveTrigger
            .withLatestFrom(address)
            .asObservable()
            .bind(to: select)
            .disposed(by: disposeBag)
        
        return Output(initLocation: initLocation, address: address, mode: Driver.just(mode))
    }

}
