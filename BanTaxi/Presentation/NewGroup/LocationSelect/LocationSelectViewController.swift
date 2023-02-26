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

class LocationSelectViewController: UIViewController {
    
    let disposeBag = DisposeBag()
    let newGroupViewModel: NewGroupViewModel!
    
    let titleString: String!
    let locationManager: CLLocationManager!
    let viewModel: LocationSelectViewModel!
    
    let mapView = MTMapView()
    let centerMarker = MTMapPOIItem()
    let addressSearchButton = UIButton()
    let saveButton = UIButton()
    
    init(_ title: String = "", newGroupViewModel: NewGroupViewModel) {
        self.newGroupViewModel = newGroupViewModel
        self.titleString  = title
        locationManager = CLLocationManager()
        viewModel = LocationSelectViewModel()
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
        
        viewModel.selectedPoint
            .subscribe(onNext: {
                print($0)
                self.centerMarker.itemName = $0.roadAddress
                self.mapView.select(self.centerMarker, animated: false)
            })
            .disposed(by: disposeBag)
        
        addressSearchButton.rx.tap
            .asDriver()
            .drive(onNext: {
                self.navigationController?.pushViewController(AddressSearchViewController(), animated: true)
            })
            .disposed(by: disposeBag)
        
        switch titleString {
            case "출발지 설정":
                saveButton.rx.tap
                    .withLatestFrom(viewModel.selectedPoint)
                    .subscribe(onNext: {
                        self.newGroupViewModel.startingPoint.accept($0)
                        self.navigationController?.popViewController(animated: true)
                    })
                    .disposed(by: disposeBag)
                
                newGroupViewModel.startingPoint
                    .filter { $0 != nil && $0?.latitude != nil && $0?.longitude != nil }
                    .map {
                        let center = MTMapPoint(geoCoord: MTMapPointGeo(latitude: $0!.latitude!, longitude: $0!.longitude!))
                        self.mapView.setMapCenter(center, zoomLevel: 1, animated: true)
                        return center!
                    }
                    .bind(to: viewModel.mapCenterPoint)
                    .disposed(by: disposeBag)
                
            case "도착지 설정":
                saveButton.rx.tap
                    .withLatestFrom(viewModel.selectedPoint)
                    .subscribe(onNext: {
                        self.newGroupViewModel.destinationPoint.accept($0)
                        self.navigationController?.popViewController(animated: true)
                    })
                    .disposed(by: disposeBag)
                
                newGroupViewModel.destinationPoint
                    .filter { $0 != nil && $0?.latitude != nil && $0?.longitude != nil }
                    .map {
                        let center = MTMapPoint(geoCoord: MTMapPointGeo(latitude: $0!.latitude!, longitude: $0!.longitude!))
                        self.mapView.setMapCenter(center, zoomLevel: 1, animated: true)
                        return center!
                    }
                    .bind(to: viewModel.mapCenterPoint)
                    .disposed(by: disposeBag)
            default: break
        }
    }
    
    private func attribute() {
        view.backgroundColor = .white
        
        title = titleString
        
        self.navigationController?.navigationBar.topItem?.title = " "
        
        addressSearchButton.setTitle("주소로 위치 검색", for: .normal)
        addressSearchButton.setTitleColor(.white, for: .normal)
        addressSearchButton.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        addressSearchButton.backgroundColor = UIColor(named: "MainColor")
        addressSearchButton.layer.cornerRadius = 5
        
        saveButton.setTitle("해당 위치로 설정", for: .normal)
        saveButton.setTitleColor(.white, for: .normal)
        saveButton.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        saveButton.backgroundColor = UIColor(named: "MainColor")
        saveButton.layer.cornerRadius = 5
        
    }
    
    private func layout() {
        [mapView, addressSearchButton, saveButton].forEach {
            view.addSubview($0)
        }
        
        mapView.snp.makeConstraints {
            $0.height.equalTo(UIScreen.main.bounds.width)
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(30)
        }
        
        addressSearchButton.snp.makeConstraints {
            $0.top.equalTo(mapView.snp.bottom).offset(20)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.height.equalTo(40)
        }
        
        saveButton.snp.makeConstraints {
            $0.top.equalTo(addressSearchButton.snp.bottom).offset(20)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.height.equalTo(40)
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


extension LocationSelectViewController: CLLocationManagerDelegate {
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

extension LocationSelectViewController: MTMapViewDelegate {
    
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

