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
    
    private let disposeBag = DisposeBag()
    private let mapCenterPoint = PublishSubject<MTMapPoint>()
    private let locationManager: CLLocationManager
    private let viewModel: LocationSelectViewModel
    
    private let mapView = MTMapView()
    private let centerMarker = MTMapPOIItem()
    private let saveButton: UIButton = {
        let button = UIButton()
        button.setTitle("해당 위치로 설정", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        button.backgroundColor = UIColor(named: "MainColor")
        button.layer.cornerRadius = 5
        return button
    }()
    
    init(viewModel: LocationSelectViewModel) {
        self.viewModel = viewModel
        locationManager = CLLocationManager()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapViewSetting()
        locationManagerSetting()
        
        bindViewModel()
        uiEvent()
        attribute()
        layout()
    }
    
    private func bindViewModel(){
        
        let viewDidAppear = rx.sentMessage(#selector(UIViewController.viewDidAppear(_:)))
            .map { _ in ()}
            .asDriver(onErrorJustReturn: ())
        
        let input = LocationSelectViewModel.Input(initLocationTrigger: viewDidAppear,
                                                  centerTrigger: mapCenterPoint.asDriver(onErrorJustReturn: MTMapPoint(geoCoord: MTMapPointGeo(latitude: 37.57861, longitude: 126.9768))),
                                                  saveTrigger: saveButton.rx.tap.asDriver())
        
        let output = viewModel.transform(input: input)
        
        output.initLocation
            .drive(onNext: { [weak self] point in
                self?.centerMarker.mapPoint = point
            })
            .disposed(by: disposeBag)
        
        output.address
            .drive(onNext: { [weak self] in
                guard let self = self else { return }
                self.centerMarker.itemName = $0.roadAddress
                self.mapView.select(self.centerMarker, animated: false)
            })
            .disposed(by: disposeBag)
        
        output.mode
            .drive(onNext: { [weak self] mode in
                switch mode {
                    case .Starting:
                        self?.title = "출발지 설정"
                    case .Destination:
                        self?.title = "도착지 설정"
                    default:
                        self?.title = "위치 설정"
                }
            })
            .disposed(by: disposeBag)
        
    }
    
    private func uiEvent() {
        saveButton.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    private func attribute() {
        view.backgroundColor = .white
        self.navigationController?.navigationBar.topItem?.title = " "
    }
    
    private func layout() {
        [mapView, saveButton].forEach {
            view.addSubview($0)
        }
        
        mapView.snp.makeConstraints {
            $0.height.equalTo(UIScreen.main.bounds.width)
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(30)
        }
    
        
        saveButton.snp.makeConstraints {
            $0.top.equalTo(mapView.snp.bottom).offset(20)
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
        self.mapCenterPoint.onNext(mapCenterPoint)
    }
    
    func mapView(_ mapView: MTMapView!, dragStartedOn mapPoint: MTMapPoint!) {
        mapView.deselect(centerMarker)
    }
    
    func mapView(_ mapView: MTMapView!, centerPointMovedTo mapCenterPoint: MTMapPoint!) {
        centerMarker.mapPoint = mapCenterPoint
    }

}

