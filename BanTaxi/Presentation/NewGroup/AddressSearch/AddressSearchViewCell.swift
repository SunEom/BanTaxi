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
    
    let roadAddressTextView = UILabel()
    let jibunAddressTextView = UILabel()
    let postCodeTextView = UILabel()
    
    func setUp(with viewModel: AddressSearchViewCellViewModel) {
        self.viewModel = viewModel
        
        roadAddressTextView.text = viewModel.roadAddress
        jibunAddressTextView.text = viewModel.jibunAddress
        postCodeTextView.text = viewModel.postCode
        
        attribute()
        layout()
    }
    
    
    private func attribute() {
        [roadAddressTextView, jibunAddressTextView, postCodeTextView].forEach {
            $0.font = .systemFont(ofSize: 15, weight: .semibold)
        }
    }
    
    private func layout() {
        [roadAddressTextView, jibunAddressTextView, postCodeTextView].forEach { contentView.addSubview($0) }
        
        roadAddressTextView.snp.makeConstraints {
            $0.top.equalTo(contentView.snp.top).offset(20)
            $0.leading.equalTo(contentView.snp.leading).offset(20)
            $0.trailing.equalTo(contentView.snp.trailing).offset(-20)
            $0.height.equalTo(15)
        }
        
        jibunAddressTextView.snp.makeConstraints {
            $0.top.equalTo(roadAddressTextView.snp.bottom).offset(10)
            $0.leading.equalTo(contentView.snp.leading).offset(20)
            $0.trailing.equalTo(contentView.snp.trailing).offset(-20)
            $0.height.equalTo(15)
        }
        
        postCodeTextView.snp.makeConstraints {
            $0.top.equalTo(jibunAddressTextView.snp.bottom).offset(10)
            $0.leading.equalTo(contentView.snp.leading).offset(20)
            $0.trailing.equalTo(contentView.snp.trailing).offset(-20)
            $0.height.equalTo(15)
        }
        
        contentView.snp.makeConstraints {
            $0.bottom.equalTo(postCodeTextView.snp.bottom).offset(20)
        }
    }

}
