//
//  GroupListCellViewController.swift
//  BanTaxi
//
//  Created by 엄태양 on 2023/03/06.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

class GroupListCellViewController: UITableViewCell {
    
    let disposeBag = DisposeBag()
    var viewModel: GroupListCellViewModel!
    
    let leftColorBar = UIView()
    
    let mainStackView = UIStackView()
    
    let dateStackView = UIStackView()
    let dayLabel = UILabel()
    let monthLabel = UILabel()
    
    let infoStackView = UIStackView()
    let nameLabel = UILabel()
    let locationLabel = UILabel()
    
    let chevronImgView = UIImageView(image: UIImage(systemName: "chevron.right"))
    
    func setUp(with groupInfo: GroupInfo) {
        viewModel = GroupListCellViewModel(groupInfo)
        
        attribute()
        layout()
    }
    
    private func attribute() {
            
        leftColorBar.backgroundColor = K.Color.mainColor

        dateStackView.axis = .vertical
        dateStackView.alignment = .center
        dateStackView.distribution = .fillEqually
        
        dayLabel.font = .systemFont(ofSize: 20, weight: .heavy)
        monthLabel.font = .systemFont(ofSize: 16, weight: .heavy)
        
        dayLabel.text = "\(Calendar.current.dateComponents([.day], from: viewModel.groupInfo.time).day!)"
        monthLabel.text = "Mar"
        
        infoStackView.axis = .vertical
        
        nameLabel.font = .systemFont(ofSize: 19, weight: .semibold)
        locationLabel.font = .systemFont(ofSize: 13, weight: .regular)
        locationLabel.textColor = .gray
        
        nameLabel.text = viewModel.groupInfo.name
        locationLabel.text = "\(viewModel.groupInfo.start.roadAddress!) → \(viewModel.groupInfo.destination.roadAddress!)"

        chevronImgView.contentMode = .scaleAspectFit
        chevronImgView.tintColor = K.Color.mainColor
    }
    
    private func layout() {
        
        [leftColorBar, dateStackView, infoStackView, chevronImgView].forEach { contentView.addSubview($0) }
        
        [dayLabel, monthLabel].forEach{ dateStackView.addArrangedSubview($0) }
        [nameLabel, locationLabel].forEach { infoStackView.addArrangedSubview($0) }
        
        
        leftColorBar.snp.makeConstraints {
            $0.width.equalTo(3)
            $0.height.equalTo(60)
            $0.top.equalTo(contentView.safeAreaLayoutGuide).offset(15)
            $0.leading.equalToSuperview().offset(15)
            $0.bottom.equalTo(contentView.safeAreaLayoutGuide).offset(-15)
        }
        
        dateStackView.snp.makeConstraints {
            $0.width.equalTo(50)
            $0.height.equalTo(40)
            $0.leading.equalTo(leftColorBar).offset(5)
            $0.centerY.equalTo(leftColorBar)
        }
        
        infoStackView.snp.makeConstraints {
            $0.height.equalTo(dateStackView)
            $0.leading.equalTo(dateStackView.snp.trailing).offset(10)
            $0.trailing.equalTo(chevronImgView.snp.leading).offset(-10)
            $0.centerY.equalTo(leftColorBar)
        }
        
        chevronImgView.snp.makeConstraints {
            $0.height.equalTo(dateStackView)
            $0.width.equalTo(15)
            $0.trailing.equalToSuperview().offset(-10)
            $0.centerY.equalTo(leftColorBar)
        }
    }
}
