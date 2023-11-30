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
    private let diseposBag = DisposeBag()
    private let viewModel: MapViewModel
    private let tapGesture = UITapGestureRecognizer()

    private let topView = UIView()
    private let contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private let closeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        return button
    }()
    private let mapView = MTMapView()
    private let sPoiItem: MTMapPOIItem = {
        let item = MTMapPOIItem()
        item.markerType = .customImage
        item.customImage = UIImage(systemName: "car.circle")
        return item
    }()
    
    private let dPoiItem: MTMapPOIItem = {
        let item = MTMapPOIItem()
        item.markerType = .customImage
        item.customImage = UIImage(systemName: "flag.checkered.circle")
        return item
    }()
    
    
    init(viewModel: MapViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind()
        uiEvent()
        attribute()
        layout()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        mapView.fitAreaToShowAllPOIItems()
    }
    
    private func uiEvent() {
        closeButton.rx.tap
            .asDriver()
            .drive(onNext:{ [weak self] in
                self?.dismiss(animated: true)
            })
            .disposed(by: diseposBag)
    }
    
    private func bind() {
        
        mapView.setMapCenter(MTMapPoint(geoCoord: MTMapPointGeo(latitude: (viewModel.start.latitude!+viewModel.destination.latitude!)/2, longitude: (viewModel.start.longitude! + viewModel.destination.latitude!)/2)), animated: false)
        sPoiItem.mapPoint = MTMapPoint(geoCoord: MTMapPointGeo(latitude: viewModel.start.latitude!, longitude: viewModel.start.longitude!))
        dPoiItem.mapPoint = MTMapPoint(geoCoord: MTMapPointGeo(latitude: viewModel.destination.latitude!, longitude: viewModel.destination.longitude!))
        mapView.addPOIItems([sPoiItem, dPoiItem])
        
    }
    
    private func attribute() {
        view.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.4)
        view.isOpaque = false
        topView.addGestureRecognizer(tapGesture)
        tapGesture.addTarget(self, action: #selector(didTapView))
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
    
    @objc
    func didTapView() {
        self.dismiss(animated: true)
    }
}
