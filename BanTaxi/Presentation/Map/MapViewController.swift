//
//  MainViewController.swift
//  BanTaxi
//
//  Created by 엄태양 on 2023/02/20.
//

import Foundation
import RxSwift
import RxCocoa
import SnapKit
import CoreLocation

class MapViewController: UIViewController {
    
    let disposeBag = DisposeBag()
    
    let locationManager: CLLocationManager!
    let viewModel: MapViewModel!
    
    let mapView = MTMapView()
    let centerMarker = MTMapPOIItem()
    
    init() {
        locationManager = CLLocationManager()
        viewModel = MapViewModel()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapViewSetting()
        locationManagerSetting()
        
        bind()
        attribute()
        layout()
    }
    
    private func bind(){
        viewModel.mapCenterPoint
            .bind(to: centerMarker.rx.mapPoint)
            .disposed(by: disposeBag)
        
        viewModel.mapCenterAddress
            .subscribe(onNext: {
                self.centerMarker.itemName = $0
                self.mapView.select(self.centerMarker, animated: false)
            })
            .disposed(by: disposeBag)
    }
    
    private func attribute() {
        view.backgroundColor = .white
        
    }
    
    private func layout() {
        [mapView].forEach {
            view.addSubview($0)
        }
        
        mapView.snp.makeConstraints {
            $0.height.equalTo(UIScreen.main.bounds.width)
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(30)
        }
    }
    
    private func locationManagerSetting() {
        //위치추적권한요청 when in foreground
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
        //배터리에 맞게 권장되는 최적의 정확도
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        if let location = locationManager.location {
            let centerPoint = MTMapPoint(geoCoord: MTMapPointGeo(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude))
            
            mapView.setMapCenter(centerPoint, zoomLevel: 1, animated: true)

        }
        
    }
    
    private func mapViewSetting() {
        mapView.delegate = self
        
        centerMarker.showDisclosureButtonOnCalloutBalloon = false

        mapView.addPOIItems([centerMarker])
    }
}


extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
            case  .authorizedAlways,
                    .authorizedWhenInUse,
                    .notDetermined:
                return
            default:
                print("Authorization Error")
                return
        }
    }
}

extension MapViewController: MTMapViewDelegate {
    
    func mapView(_ mapView: MTMapView!, finishedMapMoveAnimation mapCenterPoint: MTMapPoint!) {
        viewModel.mapCenterPoint.accept(mapCenterPoint)
    }
    
    func mapView(_ mapView: MTMapView!, dragStartedOn mapPoint: MTMapPoint!) {
        mapView.deselect(centerMarker)
    }
    
    func mapView(_ mapView: MTMapView!, centerPointMovedTo mapCenterPoint: MTMapPoint!) {
        centerMarker.mapPoint = mapCenterPoint
    }

}

