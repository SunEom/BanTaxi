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
import DateToolsSwift

class GroupListCellViewController: UITableViewCell {
    
    let disposeBag = DisposeBag()
    var viewModel: GroupListCellViewModel!
    
    let leftColorBar = UIView()
    
    let mainStackView = UIStackView()
    
    let dateStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    let dayLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .heavy)
        return label
    }()
    
    let monthLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .heavy)
        return label
    }()
    
    
    let infoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        return stackView
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 19, weight: .semibold)
        return label
    }()
    
    let locationLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.textColor = .gray
        return label
    }()
    
    let chevronImgView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "chevron.right"))
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = K.Color.mainColor
        return imageView
    }()
    
    func setUp(with groupInfo: GroupInfo) {
        viewModel = GroupListCellViewModel(groupInfo)
        
        bind()
        layout()
    }
    
    private func bind() {
        dayLabel.text = "\(viewModel.groupInfo.time.format(with: "d"))"
        monthLabel.text = "\(viewModel.groupInfo.time.format(with: "MMM"))"
        nameLabel.text = viewModel.groupInfo.name
        locationLabel.text = "\(viewModel.groupInfo.start.roadAddress!) → \(viewModel.groupInfo.destination.roadAddress!)"
    
        if viewModel.available {
            self.leftColorBar.backgroundColor = K.Color.mainColor
        } else {
            self.leftColorBar.backgroundColor = .gray
        }
    }
    
    
    
    private func layout() {
        
        [leftColorBar, dateStackView, infoStackView, chevronImgView].forEach { contentView.addSubview($0) }
        
        [dayLabel, monthLabel].forEach{ dateStackView.addArrangedSubview($0) }
        [nameLabel, locationLabel].forEach { infoStackView.addArrangedSubview($0) }
        
        
        leftColorBar.snp.makeConstraints {
            $0.width.equalTo(3)
            $0.top.leading.equalTo(contentView).offset(15)
            $0.bottom.equalTo(contentView).offset(-15)
        }
        
        dateStackView.snp.makeConstraints {
            $0.width.equalTo(50)
            $0.top.bottom.equalTo(leftColorBar)
            $0.leading.equalTo(leftColorBar).offset(5)
        }
        
        infoStackView.snp.makeConstraints {
            $0.top.bottom.equalTo(dateStackView)
            $0.leading.equalTo(dateStackView.snp.trailing).offset(10)
            $0.trailing.equalTo(chevronImgView.snp.leading).offset(-10)
        }
        
        chevronImgView.snp.makeConstraints {
            $0.top.bottom.equalTo(dateStackView)
            $0.width.equalTo(15)
            $0.trailing.equalToSuperview().offset(-10)
            $0.centerY.equalTo(leftColorBar)
        }
    }
}
