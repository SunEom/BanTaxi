//
//  MapViewController.swift
//  BanTaxi
//
//  Created by 엄태양 on 2023/03/07.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

class MapViewController: UIViewController {
    let diseposBag = DisposeBag()
    let viewModel: MapViewModel!
    let tapGesture = UITapGestureRecognizer()

    let topView = UIView()
    let contentView = UIView()
    let closeButton = UIButton()
    let mapView = MTMapView()
    let sPoiItem = MTMapPOIItem()
    let dPoiItem = MTMapPOIItem()
    
    init(start: AddressData, destination: AddressData) {
        viewModel = MapViewModel(start: start, destination: destination)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapViewSetting()
        
        bind()
        attribute()
        layout()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        mapView.fitAreaToShowAllPOIItems()
    }
    
    private func bind() {
    
        closeButton.rx.tap
            .asDriver()
            .drive(onNext:{
                self.dismiss(animated: true)
            })
            .disposed(by: diseposBag)
    }
    
    private func attribute() {
        view.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.4)
        view.isOpaque = false
        
        topView.addGestureRecognizer(tapGesture)
        tapGesture.addTarget(self, action: #selector(didTapView))
        
        contentView.backgroundColor = .white
        closeButton.setImage(UIImage(systemName: "xmark"), for: .normal)
    }
    
    private func layout() {
        [topView, contentView].forEach { view.addSubview($0) }
        [mapView, closeButton].forEach { contentView.addSubview($0)}
        
        topView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(contentView.snp.top)
        }
        
        contentView.snp.makeConstraints {
            $0.height.equalTo(UIScreen.main.bounds.height/2)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    
        closeButton.snp.makeConstraints{
            $0.width.height.equalTo(40)
            $0.trailing.equalTo(contentView).offset(-10)
            $0.top.equalTo(contentView).offset(10)
        }
        
        mapView.snp.makeConstraints {
            $0.top.equalTo(closeButton.snp.bottom).offset(10)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.height.equalTo(300)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-30)
        }
    }
    
    private func mapViewSetting() {
        
        mapView.setMapCenter(MTMapPoint(geoCoord: MTMapPointGeo(latitude: (viewModel.start.latitude!+viewModel.destination.latitude!)/2, longitude: (viewModel.start.longitude! + viewModel.destination.latitude!)/2)), animated: false)
        sPoiItem.mapPoint = MTMapPoint(geoCoord: MTMapPointGeo(latitude: viewModel.start.latitude!, longitude: viewModel.start.longitude!))
        sPoiItem.markerType = .customImage
        sPoiItem.customImage = UIImage(systemName: "car.circle")
        dPoiItem.mapPoint = MTMapPoint(geoCoord: MTMapPointGeo(latitude: viewModel.destination.latitude!, longitude: viewModel.destination.longitude!))
        dPoiItem.markerType = .customImage
        dPoiItem.customImage = UIImage(systemName: "flag.checkered.circle")
        mapView.addPOIItems([sPoiItem, dPoiItem])
    }
    
    @objc
    func didTapView() {
        self.dismiss(animated: true)
    }
}
