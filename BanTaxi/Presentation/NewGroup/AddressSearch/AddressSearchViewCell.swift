//
//  AddressSearchViewCell.swift
//  BanTaxi
//
//  Created by 엄태양 on 2023/02/26.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

class AddressSearchViewCell: UITableViewCell {

    let disposeBag = DisposeBag()
    var viewModel: AddressSearchViewCellViewModel!
    
    let roadAddressLabel = UILabel()
    let jibunAddressLabel = UILabel()
    let placeNameLabel = UILabel()
    
    func setUp(with viewModel: AddressSearchViewCellViewModel) {
        self.viewModel = viewModel
        
        roadAddressLabel.text = viewModel.roadAddress
        jibunAddressLabel.text = viewModel.jibunAddress
        placeNameLabel.text = viewModel.placeName
        
        attribute()
        layout()
    }
    
    
    private func attribute() {
        [roadAddressLabel, jibunAddressLabel, placeNameLabel].forEach {
            $0.font = .systemFont(ofSize: 15, weight: .semibold)
        }
    }
    
    private func layout() {
        [placeNameLabel, roadAddressLabel, jibunAddressLabel].forEach { contentView.addSubview($0) }
        
        placeNameLabel.snp.makeConstraints {
            $0.top.equalTo(contentView.snp.top).offset(20)
            $0.leading.equalTo(contentView.snp.leading).offset(20)
            $0.trailing.equalTo(contentView.snp.trailing).offset(-20)
            $0.height.equalTo(15)
        }
        
        roadAddressLabel.snp.makeConstraints {
            $0.top.equalTo(placeNameLabel.snp.bottom).offset(10)
            $0.leading.equalTo(contentView.snp.leading).offset(20)
            $0.trailing.equalTo(contentView.snp.trailing).offset(-20)
            $0.height.equalTo(15)
        }
        
        jibunAddressLabel.snp.makeConstraints {
            $0.top.equalTo(roadAddressLabel.snp.bottom).offset(10)
            $0.leading.equalTo(contentView.snp.leading).offset(20)
            $0.trailing.equalTo(contentView.snp.trailing).offset(-20)
            $0.height.equalTo(15)
        }
        
        contentView.snp.makeConstraints {
            $0.bottom.equalTo(jibunAddressLabel.snp.bottom).offset(20)
        }
    }

}
