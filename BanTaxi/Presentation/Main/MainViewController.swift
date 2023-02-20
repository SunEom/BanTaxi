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

class MainViewController: UIViewController {
    
    let disposeBag = DisposeBag()
    
    let locationManager = CLLocationManager()
    
    let titleLabel = UILabel()
    let mapView = MTMapView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        
        locationManagerSetting()
        
        bind(MainViewModel())
        attribute()
        layout()
    }
    
    private func bind(_ viewModel: MainViewModel){
        
    }
    
    private func attribute() {
        view.backgroundColor = .white
        
        titleLabel.text = "BanTaxi"
        titleLabel.font = .systemFont(ofSize: 30, weight: .heavy)
        titleLabel.textColor = UIColor(named: "MainColor")
    }
    
    private func layout() {
        [titleLabel, mapView].forEach {
            view.addSubview($0)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(40)
            $0.trailing.equalToSuperview()
            $0.leading.equalToSuperview().offset(30)
            $0.height.equalTo(40)
        }
        
        mapView.snp.makeConstraints {
            $0.height.equalTo(400)
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(titleLabel.snp.bottom).offset(30)
        }
    }
    
    private func locationManagerSetting() {
        //위치추적권한요청 when in foreground
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
        //배터리에 맞게 권장되는 최적의 정확도
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        if let location = locationManager.location {
            mapView.setMapCenter(MTMapPoint(geoCoord: MTMapPointGeo(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)), zoomLevel: 1, animated: true)
        }
        
    }
}


extension MainViewController: CLLocationManagerDelegate {
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
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        //위도, 경도 가져오기
        let currentLocation = "\(locValue.latitude), \(locValue.longitude)"
        
        print(currentLocation)
    }
}

extension MainViewController: MTMapViewDelegate {
    func mapView(_ mapView: MTMapView!, finishedMapMoveAnimation mapCenterPoint: MTMapPoint!) {
        print(mapCenterPoint!.mapPointGeo())
    }
}
