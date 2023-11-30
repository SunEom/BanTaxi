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
    private let disposeBag = DisposeBag()
    private let viewModel: GroupDetailViewModel!
    
    private let activityIndicator = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: K.ScreenSize.width, height: K.ScreenSize.height), type: .circleStrokeSpin, color: K.Color.mainColor, padding: 200)
    
    private let deleteButton = UIBarButtonItem(image: UIImage(systemName: "trash"), style: .plain, target: nil, action: nil)
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 23, weight: .bold)
        return label
    }()
    
    
    private let timeImgView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "timer"))
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = K.Color.mainColor
        return imageView
    }()
    private let timeTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .black
        label.text = "예정 시각"
        return label
    }()
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.textAlignment = .right
        return label
    }()
    
    private let intakeImgView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "person.3"))
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = K.Color.mainColor
        return imageView
    }()
    
    private let intakeTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .black
        label.text = "모집 인원"
        return label
    }()
    
    private let intakeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.textAlignment = .right
        return label
    }()
    
    private let startTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .black
        label.text = "출발 주소"
        return label
    }()
    
    private let startImgView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "car.circle"))
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = K.Color.mainColor
        return imageView
    }()
    
    private let startLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.textAlignment = .right
        label.font = .systemFont(ofSize: 16, weight: .regular)
        return label
    }()
    
    
    private let destiTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .black
        label.text = "도착 주소"
        return label
    }()
    
    private let destiImgView: UIImageView = {
       let imageView = UIImageView(image: UIImage(systemName: "flag.checkered.circle"))
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = K.Color.mainColor
        return imageView
    }()
    
    private let destiLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.textAlignment = .right
        label.font = .systemFont(ofSize: 16, weight: .regular)
        return label
    }()
    
    
    private let mapButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.setTitle("지도에서 보기", for: .normal)
        button.setTitleColor(K.Color.mainColor, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 15, weight: .semibold)
        button.layer.cornerRadius = 5
        button.layer.borderWidth = 1
        button.layer.borderColor = K.Color.mainColor?.cgColor
        return button
    }()
    
    private let joinButton: UIButton = {
        let button = UIButton()
        button.setTitle("그룹 참여하기", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 15, weight: .semibold)
        button.layer.cornerRadius = 5
        return button
    }()
    
    private let exitButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .red
        button.setTitle("그룹에서 나가기", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 15, weight: .semibold)
        button.layer.cornerRadius = 5
        return button
    }()
    
    private let chatButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = K.Color.mainColor
        button.setTitle("채팅방", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 15, weight: .semibold)
        button.setImage(UIImage(systemName: "ellipsis.bubble.fill"), for: .normal)
        button.tintColor = .white
        button.layer.cornerRadius = 5
        button.semanticContentAttribute = .forceRightToLeft
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 15)
        return button
    }()
    
    
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
        
        let viewWillAppear = rx.sentMessage(#selector(UIViewController.viewWillAppear(_:))).map { _ in () }.asDriver(onErrorJustReturn: ())
        
        let delete = PublishSubject<Void>()
        
        let input = GroupDetailViewModel.Input(fetchTrigger: viewWillAppear,
                                               deleteTrigger: delete.asDriver(onErrorJustReturn: ()),
                                               joinTrigger: joinButton.rx.tap.asDriver(),
                                               exitTrigger: exitButton.rx.tap.asDriver())
        
        let output = viewModel.transform(input: input)
        
        output.loading
            .drive(onNext: { [weak self] loading in
                if loading {
                    self?.activityIndicator.startAnimating()
                    self?.activityIndicator.isHidden = false
                } else {
                    self?.activityIndicator.stopAnimating()
                    self?.activityIndicator.isHidden = true
                }
            })
            .disposed(by: disposeBag)
        
        
        
        output.available
            .drive(onNext: { available in
                if available {
                    self.joinButton.backgroundColor = K.Color.mainColor
                    self.joinButton.isEnabled = true
                } else {
                    self.joinButton.backgroundColor = .gray
                    self.joinButton.isEnabled = false
                }
            })
            .disposed(by: disposeBag)

        
        output.group
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] group in
                guard let self = self else { return }
                nameLabel.text = group.name
                timeLabel.text = group.time.format(with: "yyyy. MM. dd. aa hh:mm", locale: Locale(identifier: "ko-kr"))
                intakeLabel.text = "\(group.participantsCount)/\(group.intake)"
                startLabel.text = group.start.roadAddress!
                destiLabel.text = group.destination.roadAddress!
            })
            .disposed(by: disposeBag)
        
        mapButton.rx.tap
            .withLatestFrom(output.group)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] groupInfo in
                let pvc = MapViewController(viewModel: MapViewModel(start: groupInfo.start, destination: groupInfo.destination))
                pvc.modalPresentationStyle = .overCurrentContext
                pvc.modalTransitionStyle = .coverVertical
                self?.present(pvc, animated: true)
            })
            .disposed(by: disposeBag)
        
        output.isMine
            .map{ !$0 }
            .drive(deleteButton.rx.isHidden)
            .disposed(by: disposeBag)
        
        output.alreadyJoin
            .map{ !$0 }
            .drive(chatButton.rx.isHidden)
            .disposed(by: disposeBag)
        
        output.alreadyJoin
            .drive(joinButton.rx.isHidden)
            .disposed(by: disposeBag)
        
        Driver.combineLatest(output.isMine, output.alreadyJoin)
            .map{ $0 || !$1 }
            .drive(exitButton.rx.isHidden)
            .disposed(by: disposeBag)
        
        deleteButton.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] in
                let alert = UIAlertController(title: "삭제", message: "정말로 그룹을 삭제하시겠습니까?", preferredStyle: .alert)
                let confirm = UIAlertAction(title: "삭제", style: .destructive) { _ in
                    delete.onNext(())
                }
                let cancel = UIAlertAction(title: "취소", style: .cancel)
                alert.addAction(confirm)
                alert.addAction(cancel)
                self?.present(alert, animated: true)
            })
            .disposed(by: disposeBag)
        
        output.result
            .drive(onNext: {[weak self] result in
                if result.isSuccess {
                    let alert = UIAlertController(title: "성공", message: "그룹이 삭제되었습니다.", preferredStyle: .alert)
                    let action = UIAlertAction(title: "확인", style: .default) { _ in
                        self?.navigationController?.popViewController(animated: true)
                    }
                    alert.addAction(action)
                    self?.present(alert, animated: true)
                } else {
                    let alert = UIAlertController(title: "오류", message: result.msg, preferredStyle: .alert)
                    let action = UIAlertAction(title: "확인", style: .default)
                    alert.addAction(action)
                    self?.present(alert, animated: true)
                }
            })
            .disposed(by: disposeBag)

        chatButton.rx.tap
            .observe(on: MainScheduler.instance)
            .withLatestFrom(output.group)
            .subscribe(onNext:{[weak self] groupInfo in
                self?.navigationController?.pushViewController(ChatRoomViewController(groupInfo: groupInfo), animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    private func attribute() {
        view.backgroundColor = .white
        
        navigationItem.rightBarButtonItem = deleteButton
        navigationItem.rightBarButtonItem?.tintColor = .red
        
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
