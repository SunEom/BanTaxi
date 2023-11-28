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
    
    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 5
        return stackView
    }()
    
    let placeNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .bold)
        return label
    }()
    
    let roadAddressLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .semibold)
        return label
    }()
    
    let jibunAddressLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .semibold)
        return label
    }()
    
    
    
    func setUp(with viewModel: AddressSearchViewCellViewModel) {
        self.viewModel = viewModel
        
        bind()
        layout()
    }
    
    private func bind() {
        placeNameLabel.text = viewModel.placeName
        roadAddressLabel.text = viewModel.roadAddress
        jibunAddressLabel.text = viewModel.jibunAddress
    }
    
    
    private func layout() {
        
        contentView.addSubview(stackView)
        
        [placeNameLabel, roadAddressLabel, jibunAddressLabel].forEach { stackView.addArrangedSubview($0) }
        
        stackView.snp.makeConstraints {
            $0.top.leading.equalTo(contentView).offset(20)
            $0.trailing.bottom.equalTo(contentView).offset(-20)
        }
    
    }

}
