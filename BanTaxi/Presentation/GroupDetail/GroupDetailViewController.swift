//
//  GroupDetailViewController.swift
//  BanTaxi
//
//  Created by 엄태양 on 2023/03/06.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

class GroupDetailViewController: UIViewController {
    let disposeBag = DisposeBag()
    let viewModel: GroupDetailViewModel!
    
    let nameLabel = UILabel()
    
    let timeImgView = UIImageView(image: UIImage(systemName: "timer"))
    let timeTitleLabel = UILabel()
    let timeLabel = UILabel()
    
    let intakeImgView = UIImageView(image: UIImage(systemName: "person.3"))
    let intakeTitleLabel = UILabel()
    let intakeLabel = UILabel()
    
    let startTitleLabel = UILabel()
    let startImgView = UIImageView(image: UIImage(systemName: "car.circle"))
    let startLabel = UILabel()
    
    let destiTitleLabel = UILabel()
    let destiImgView = UIImageView(image: UIImage(systemName: "flag.checkered.circle"))
    let destiLabel = UILabel()
    
    let mapButton = UIButton()
    
    let joinButton = UIButton()
    let exitButton = UIButton()
    let chatButton = UIButton()
    
    init(with groupInfo: GroupInfo) {
        viewModel = GroupDetailViewModel(with: groupInfo)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind()
        attribute()
        layout()
    }

    private func bind() {
        mapButton.rx.tap
            .asDriver()
            .drive(onNext: {
                let pvc = MapViewController(start: self.viewModel.groupInfo.start, destination: self.viewModel.groupInfo.destination)
                pvc.modalPresentationStyle = .overCurrentContext
                pvc.modalTransitionStyle = .coverVertical
                self.present(pvc, animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    private func attribute() {
        view.backgroundColor = .white
        
        nameLabel.text = viewModel.groupInfo.name
        nameLabel.font = .systemFont(ofSize: 23, weight: .bold)
        
        [timeTitleLabel, intakeTitleLabel, startTitleLabel, destiTitleLabel].forEach {
            $0.font = .systemFont(ofSize: 16, weight: .semibold)
            $0.textColor = .black
        }
        
        [timeImgView, intakeImgView, startImgView, destiImgView].forEach {
            $0.contentMode = .scaleAspectFit
            $0.tintColor = K.Color.mainColor
        }
        
        timeTitleLabel.text = "예정 시각"
        
        [timeLabel, intakeLabel, startLabel, destiLabel].forEach {
            $0.font = .systemFont(ofSize: 16, weight: .regular)
            $0.textAlignment = .right
        }
        startLabel.font = .systemFont(ofSize: 16, weight: .regular)
        destiLabel.font = .systemFont(ofSize: 16, weight: .regular)
        
        timeLabel.text = viewModel.groupInfo.time.format(with: "yyyy. MM. dd. aa hh:mm", locale: Locale(identifier: "ko-kr"))
        
        intakeTitleLabel.text = "모집 인원"
        intakeLabel.text = "1/\(viewModel.groupInfo.intake)"
        
        startTitleLabel.text = "출발 주소"
        destiTitleLabel.text = "도착 주소"
        
        startLabel.text = viewModel.groupInfo.start.roadAddress!
        destiLabel.text = viewModel.groupInfo.destination.roadAddress!
        
        mapButton.backgroundColor = .white
        mapButton.setTitle("지도에서 보기", for: .normal)
        mapButton.setTitleColor(K.Color.mainColor, for: .normal)
        mapButton.titleLabel?.font = .systemFont(ofSize: 15, weight: .semibold)
        mapButton.layer.cornerRadius = 5
        mapButton.layer.borderWidth = 1
        mapButton.layer.borderColor = K.Color.mainColor?.cgColor
        
        joinButton.backgroundColor = K.Color.mainColor
        joinButton.setTitle("그룹 참여하기", for: .normal)
        joinButton.setTitleColor(.white, for: .normal)
        joinButton.titleLabel?.font = .systemFont(ofSize: 15, weight: .semibold)
        joinButton.layer.cornerRadius = 5
        
    }
    
    private func layout() {
            
        [nameLabel, timeImgView, timeTitleLabel, timeLabel, intakeImgView, intakeTitleLabel, intakeLabel, startImgView, startTitleLabel, startLabel, destiImgView, destiTitleLabel, destiLabel, mapButton, joinButton].forEach { view.addSubview($0)}
    
        nameLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(30)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
        }
        
        timeImgView.snp.makeConstraints {
            $0.top.equalTo(nameLabel.snp.bottom).offset(30)
            $0.width.height.equalTo(25)
            $0.leading.equalTo(nameLabel)
        }
        
        timeTitleLabel.snp.makeConstraints {
            $0.centerY.equalTo(timeImgView)
            $0.leading.equalTo(timeImgView.snp.trailing).offset(15)
            $0.trailing.equalTo(timeLabel.snp.leading)
        }
        
        timeLabel.snp.makeConstraints {
            $0.centerY.equalTo(timeImgView)
            $0.leading.equalTo(timeTitleLabel.snp.trailing)
            $0.trailing.equalTo(nameLabel)
        }
        
        intakeImgView.snp.makeConstraints {
            $0.top.equalTo(timeTitleLabel.snp.bottom).offset(10)
            $0.width.height.equalTo(30)
            $0.leading.equalTo(nameLabel)
        }
        
        intakeTitleLabel.snp.makeConstraints {
            $0.centerY.equalTo(intakeImgView)
            $0.leading.equalTo(intakeImgView.snp.trailing).offset(10)
            $0.trailing.equalTo(intakeLabel.snp.leading)
        }
        
        intakeLabel.snp.makeConstraints {
            $0.centerY.equalTo(intakeImgView)
            $0.leading.equalTo(intakeTitleLabel.snp.trailing)
            $0.trailing.equalTo(nameLabel)
        }
        
        startImgView.snp.makeConstraints {
            $0.top.equalTo(intakeImgView.snp.bottom).offset(10)
            $0.width.height.equalTo(25)
            $0.leading.equalTo(nameLabel)
        }
        
        startTitleLabel.snp.makeConstraints {
            $0.centerY.equalTo(startImgView)
            $0.leading.equalTo(startImgView.snp.trailing).offset(15)
            $0.trailing.equalTo(nameLabel)
        }
        
        startLabel.snp.makeConstraints {
            $0.top.equalTo(startImgView.snp.bottom).offset(5)
            $0.leading.trailing.equalTo(nameLabel)
        }
        
        destiImgView.snp.makeConstraints {
            $0.top.equalTo(startLabel.snp.bottom).offset(10)
            $0.width.height.equalTo(25)
            $0.leading.equalTo(nameLabel)
        }
        
        destiTitleLabel.snp.makeConstraints {
            $0.centerY.equalTo(destiImgView)
            $0.leading.equalTo(destiImgView.snp.trailing).offset(15)
            $0.trailing.equalTo(nameLabel)
        }
        
        destiLabel.snp.makeConstraints {
            $0.top.equalTo(destiImgView.snp.bottom).offset(5)
            $0.leading.trailing.equalTo(nameLabel)
        }
        
        mapButton.snp.makeConstraints {
            $0.top.equalTo(destiLabel.snp.bottom).offset(30)
            $0.leading.trailing.equalTo(nameLabel)
            $0.height.equalTo(35)
        }
        
        joinButton.snp.makeConstraints {
            $0.top.equalTo(mapButton.snp.bottom).offset(20)
            $0.leading.trailing.equalTo(nameLabel)
            $0.height.equalTo(35)
        }
    }

}
