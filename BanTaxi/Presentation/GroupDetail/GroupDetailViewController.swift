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
import NVActivityIndicatorView

class GroupDetailViewController: UIViewController {
    let disposeBag = DisposeBag()
    let viewModel: GroupDetailViewModel!
    
    let activityIndicator = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: K.ScreenSize.width, height: K.ScreenSize.height), type: .circleStrokeSpin, color: K.Color.mainColor, padding: 200)
    
    let deleteButton = UIBarButtonItem(image: UIImage(systemName: "trash"), style: .plain, target: nil, action: nil)
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.fetchRequest.onNext(Void())
    }

    private func bind() {
        
        viewModel.isLoading
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { loading in
                if loading {
                    self.activityIndicator.startAnimating()
                    self.activityIndicator.isHidden = false
                } else {
                    self.activityIndicator.stopAnimating()
                    self.activityIndicator.isHidden = true
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.groupInfo
            .map { $0.name }
            .bind(to: nameLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.groupInfo
            .map { $0.time.format(with: "yyyy. MM. dd. aa hh:mm", locale: Locale(identifier: "ko-kr")) }
            .bind(to: timeLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.groupInfo
            .map { "\($0.participantsCount)/\($0.intake)" }
            .bind(to: intakeLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.groupInfo
            .map { $0.start.roadAddress! }
            .bind(to: startLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.groupInfo
            .map { $0.destination.roadAddress! }
            .bind(to: destiLabel.rx.text)
            .disposed(by: disposeBag)
        
        mapButton.rx.tap
            .observe(on: MainScheduler.instance)
            .withLatestFrom(viewModel.groupInfo)
            .subscribe(onNext: { groupInfo in
                let pvc = MapViewController(start: groupInfo.start, destination: groupInfo.destination)
                pvc.modalPresentationStyle = .overCurrentContext
                pvc.modalTransitionStyle = .coverVertical
                self.present(pvc, animated: true)
            })
            .disposed(by: disposeBag)
        
        viewModel.isMine
            .observe(on: MainScheduler.instance)
            .map{ !$0 }
            .bind(to: deleteButton.rx.isHidden)
            .disposed(by: disposeBag)
        
        viewModel.alreadyJoin
            .observe(on: MainScheduler.instance)
            .map{ !$0 }
            .bind(to: chatButton.rx.isHidden)
            .disposed(by: disposeBag)
        
        Observable.combineLatest(viewModel.isMine, viewModel.alreadyJoin)
            .observe(on: MainScheduler.instance)
            .map{ $0 || !$1 }
            .bind(to: exitButton.rx.isHidden)
            .disposed(by: disposeBag)
        
        viewModel.alreadyJoin
            .observe(on: MainScheduler.instance)
            .bind(to: joinButton.rx.isHidden)
            .disposed(by: disposeBag)
        
        deleteButton.rx.tap
            .asDriver()
            .drive(onNext: {
                let alert = UIAlertController(title: "삭제", message: "정말로 그룹을 삭제하시겠습니까?", preferredStyle: .alert)
                let confirm = UIAlertAction(title: "삭제", style: .destructive) { _ in
                    self.viewModel.deleteRequest.onNext(Void())
                }
                let cancel = UIAlertAction(title: "취소", style: .cancel)
                alert.addAction(confirm)
                alert.addAction(cancel)
                self.present(alert, animated: true)
            })
            .disposed(by: disposeBag)
        
        viewModel.deleteRequestResult
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { result in
                if result.isSuccess {
                    let alert = UIAlertController(title: "성공", message: "그룹이 삭제되었습니다.", preferredStyle: .alert)
                    let action = UIAlertAction(title: "확인", style: .default) { _ in
                        self.navigationController?.popViewController(animated: true)
                    }
                    alert.addAction(action)
                    self.present(alert, animated: true)
                } else {
                    print(result.msg)
                    let alert = UIAlertController(title: "오류", message: "오류가 발생했습니다.\n잠시후에 다시 시도해주세요.", preferredStyle: .alert)
                    let action = UIAlertAction(title: "확인", style: .default)
                    alert.addAction(action)
                    self.present(alert, animated: true)
                }
            })
            .disposed(by: disposeBag)
        
        joinButton.rx.tap
            .bind(to: viewModel.joinRequest)
            .disposed(by: disposeBag)
        
        exitButton.rx.tap
            .bind(to: viewModel.exitRequest)
            .disposed(by: disposeBag)
        
        chatButton.rx.tap
            .observe(on: MainScheduler.instance)
            .withLatestFrom(self.viewModel.groupInfo)
            .subscribe(onNext:{ groupInfo in
                self.navigationController?.pushViewController(ChatRoomViewController(groupInfo: groupInfo), animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    private func attribute() {
        view.backgroundColor = .white
        
        navigationItem.rightBarButtonItem = deleteButton
        navigationItem.rightBarButtonItem?.tintColor = .red
        
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
    
        intakeTitleLabel.text = "모집 인원"
        
        startTitleLabel.text = "출발 주소"
        destiTitleLabel.text = "도착 주소"
        
        mapButton.backgroundColor = .white
        mapButton.setTitle("지도에서 보기", for: .normal)
        mapButton.setTitleColor(K.Color.mainColor, for: .normal)
        mapButton.titleLabel?.font = .systemFont(ofSize: 15, weight: .semibold)
        mapButton.layer.cornerRadius = 5
        mapButton.layer.borderWidth = 1
        mapButton.layer.borderColor = K.Color.mainColor?.cgColor
        
        [joinButton, chatButton, exitButton].forEach { $0.isHidden = true }
        
        joinButton.backgroundColor = K.Color.mainColor
        joinButton.setTitle("그룹 참여하기", for: .normal)
        joinButton.setTitleColor(.white, for: .normal)
        joinButton.titleLabel?.font = .systemFont(ofSize: 15, weight: .semibold)
        joinButton.layer.cornerRadius = 5
        
        chatButton.backgroundColor = K.Color.mainColor
        chatButton.setTitle("채팅방", for: .normal)
        chatButton.setTitleColor(.white, for: .normal)
        chatButton.titleLabel?.font = .systemFont(ofSize: 15, weight: .semibold)
        chatButton.setImage(UIImage(systemName: "ellipsis.bubble.fill"), for: .normal)
        chatButton.tintColor = .white
        chatButton.layer.cornerRadius = 5
        chatButton.semanticContentAttribute = .forceRightToLeft
        chatButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 15)
        
        exitButton.backgroundColor = .red
        exitButton.setTitle("그룹에서 나가기", for: .normal)
        exitButton.setTitleColor(.white, for: .normal)
        exitButton.titleLabel?.font = .systemFont(ofSize: 15, weight: .semibold)
        exitButton.layer.cornerRadius = 5
        
    }
    
    private func layout() {
            
        [nameLabel, timeImgView, timeTitleLabel, timeLabel, intakeImgView, intakeTitleLabel, intakeLabel, startImgView, startTitleLabel, startLabel, destiImgView, destiTitleLabel, destiLabel, mapButton, joinButton, chatButton, exitButton, activityIndicator].forEach { view.addSubview($0)}
    
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
        
        chatButton.snp.makeConstraints {
            $0.top.equalTo(mapButton.snp.bottom).offset(20)
            $0.leading.trailing.equalTo(nameLabel)
            $0.height.equalTo(35)
        }
        
        exitButton.snp.makeConstraints {
            $0.top.equalTo(chatButton.snp.bottom).offset(20)
            $0.leading.trailing.equalTo(nameLabel)
            $0.height.equalTo(35)
        }
    }

}
