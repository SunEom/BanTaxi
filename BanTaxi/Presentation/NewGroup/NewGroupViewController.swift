//
//  NewGroupViewController.swift
//  BanTaxi
//
//  Created by 엄태양 on 2023/02/24.
//

import UIKit
import RxSwift
import RxCocoa
import NVActivityIndicatorView

class NewGroupViewController: UIViewController {
    
    private let disposeBag = DisposeBag()
    private let viewModel: NewGroupViewModel!
    
    private let activityIndicator = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: K.ScreenSize.width, height: K.ScreenSize.height), type: .circleStrokeSpin, color: K.Color.mainColor, padding: 200)
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let saveButton = UIBarButtonItem(title: "저장", style: .done, target: nil, action: nil)
    
    private let nameStackView = UIStackView()
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "그룹 이름"
        return label
    }()
    
    private let nameTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .white
        textField.placeholder = "그룹 이름 입력"
        return textField
    }()
    
    private let startingPointStackView = UIStackView()
    private let startingPointLabel: UILabel = {
        let label = UILabel()
        label.text = "출발지"
        return label
    }()
    
    private let startingPointTextView = UITextView()
    private let startingPointButtonStackView = UIStackView()
    private let startingPointMapButton: UIButton = {
        let button = UIButton()
        button.setTitle( "지도에서 찾기", for: .normal)
        return button
    }()
    
    private let startingPointSearchButton: UIButton = {
        let button = UIButton()
        button.setTitle( "주소 검색하기", for: .normal)
        return button
    }()
    
    
    private let destinationStackView = UIStackView()
    private let destinationLabel: UILabel = {
        let label = UILabel()
        label.text = "도착지"
        return label
    }()
    
    private let destinationTextView = UITextView()
    private let destinationButtonStackView = UIStackView()
    private let destinationMapButton: UIButton = {
        let button = UIButton()
        button.setTitle("지도에서 찾기", for: .normal)
        return button
    }()
    
    private let destinationSearchButton: UIButton = {
        let button = UIButton()
        button.setTitle("주소 검색하기", for: .normal)
        return button
    }()
    
    
    private let timeInTakeStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 10
        return stackView
    }()
    
    private let timeStackView = UIStackView()
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.text = "예정 시각"
        return label
    }()
    
    private let timePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .time
        picker.preferredDatePickerStyle = .wheels
        picker.locale = Locale(identifier: "ko-KR")
        picker.setDate(Date.now, animated: true)
        return picker
    }()
    
    private let intakeStackView = UIStackView()
    private let intakeLabel: UILabel = {
        let label = UILabel()
        label.text = "모집인원 (본인 포함)"
        return label
    }()
    
    private let intakePicker = UIPickerView()
    
    init(viewModel: NewGroupViewModel) {
        self.viewModel = viewModel
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
        title = "새 그룹 만들기"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.navigationBar.tintColor = UIColor(named: "MainColor")
    }
    
    private func bind() {
        
        let startingPoint = BehaviorSubject<AddressData?>(value: nil)
        let destination = BehaviorSubject<AddressData?>(value: nil)
        
        let input = NewGroupViewModel.Input(groupName: nameTextField.rx.text.orEmpty.asDriver(),
                                            time: timePicker.rx.date.asDriver(),
                                            intakeSelect: intakePicker.rx.itemSelected.map { $0.row }.asDriver(onErrorJustReturn: 0), 
                                            startingPoint: startingPoint.asDriver(onErrorJustReturn: nil),
                                            destinationPoint: destination.asDriver(onErrorJustReturn: nil),
                                            saveTrigger: saveButton.rx.tap.asDriver())
        
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

        
        output.intakeCountList
            .drive(intakePicker.rx.itemTitles) { _, item in
                return "\(item)명"
            }
            .disposed(by: disposeBag)
        
        output.result
            .drive(onNext:{ result in
                if result.isSuccess {
                    let alert = UIAlertController(title: "성공", message: "새로운 그룹을 만들었습니다.", preferredStyle: .alert)
                    let action = UIAlertAction(title: "확인", style: .default) { _ in
                        self.navigationController?.popViewController(animated: true)
                    }
                    alert.addAction(action)
                    self.present(alert, animated: true)
                } else {
                    let alert = UIAlertController(title: "오류", message: result.msg, preferredStyle: .alert)
                    let action = UIAlertAction(title: "확인", style: .default)
                    alert.addAction(action)
                    self.present(alert, animated: true)
                }
            })
            .disposed(by: disposeBag)
        

        startingPointMapButton.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] in
                guard let self = self else { return }
                self.navigationController?.pushViewController(LocationSelectViewController(viewModel: LocationSelectViewModel(mode: .Starting, select: startingPoint)), animated: true)
            })
            .disposed(by: disposeBag)
        
        startingPointSearchButton.rx.tap
            .asDriver()
            .drive(onNext:  { [weak self] in
                guard let self = self else { return }
                self.navigationController?.pushViewController(AddressSearchViewController(viewModel: AddressSearchViewModel(mode: .Starting, select: startingPoint)), animated: true)
            })
            .disposed(by: disposeBag)
        
        destinationMapButton.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] in
                guard let self = self else { return }
                self.navigationController?.pushViewController(LocationSelectViewController(viewModel: LocationSelectViewModel(mode: .Destination, select: destination)), animated: true)
            })
            .disposed(by: disposeBag)
        
        destinationSearchButton.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] in
                guard let self = self else { return }
                self.navigationController?.pushViewController(AddressSearchViewController(viewModel: AddressSearchViewModel(mode: .Destination, select: destination)), animated: true)
            })
            .disposed(by: disposeBag)
        
        startingPoint
            .debug()
            .map { $0?.roadAddress ?? "아직 선택된 출발지가 없습니다" }
            .bind(to: startingPointTextView.rx.text)
            .disposed(by: disposeBag)
        
        destination
            .map { $0?.roadAddress ?? "아직 선택된 도착지가 없습니다" }
            .bind(to: destinationTextView.rx.text)
            .disposed(by: disposeBag)
        
    }
    
    private func attribute() {
        
        view.addTapGesture()
        view.backgroundColor = UIColor(white: 0.95, alpha: 1)
        navigationItem.rightBarButtonItem = saveButton
        
        
        [nameStackView, startingPointStackView, destinationStackView, timeStackView, intakeStackView].forEach {
            $0.axis = .vertical
            $0.spacing = 5
            $0.backgroundColor = .white
            $0.layer.cornerRadius = 10
            $0.layoutMargins = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
            $0.isLayoutMarginsRelativeArrangement = true
            $0.distribution = .equalSpacing
        }
        
        [startingPointButtonStackView, destinationButtonStackView].forEach {
            $0.distribution = .fillEqually
            $0.spacing = 10
        }
        
        [nameLabel, startingPointLabel, destinationLabel, timeLabel, intakeLabel].forEach {
            $0.font = .systemFont(ofSize: 11, weight: .bold)
            $0.textColor = .gray
        }
        
        [startingPointTextView, destinationTextView].forEach {
            $0.isEditable = false
        }
        
        [startingPointMapButton, startingPointSearchButton, destinationMapButton, destinationSearchButton].forEach {
            $0.setTitleColor(.white, for: .normal)
            $0.backgroundColor = UIColor(named: "MainColor")
            $0.layer.cornerRadius = 5
            $0.titleLabel?.font = .systemFont(ofSize: 15, weight: .semibold)
        }
        
    }
    
    private func layout() {
        view.addSubview(scrollView)
        view.addSubview(activityIndicator)

        scrollView.addSubview(contentView)
        
        [nameStackView, startingPointStackView, destinationStackView, timeInTakeStackView].forEach { contentView.addSubview($0)}
        [timeStackView, intakeStackView].forEach { timeInTakeStackView.addArrangedSubview($0) }
        [nameLabel, nameTextField].forEach { nameStackView.addArrangedSubview($0) }
        
        [startingPointLabel, startingPointTextView, startingPointButtonStackView].forEach { startingPointStackView.addArrangedSubview($0) }
        [startingPointMapButton, startingPointSearchButton].forEach { startingPointButtonStackView.addArrangedSubview($0)}
        
        [destinationLabel, destinationTextView, destinationButtonStackView].forEach { destinationStackView.addArrangedSubview($0) }
        [destinationMapButton, destinationSearchButton].forEach { destinationButtonStackView.addArrangedSubview($0)}
        
        [timeLabel, timePicker].forEach { timeStackView.addArrangedSubview($0) }
        [intakeLabel, intakePicker].forEach { intakeStackView.addArrangedSubview($0) }
        
        
        activityIndicator.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        scrollView.snp.makeConstraints {
            $0.top.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalTo(view)
        }
        
        contentView.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(scrollView)
            $0.bottom.equalTo(destinationStackView.snp.bottom)
            $0.width.equalTo(UIScreen.main.bounds.width)
        }
        
        nameStackView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.height.equalTo(70)
        }
        
        nameLabel.snp.makeConstraints {
            $0.height.equalTo(20)
        }
        
        timeInTakeStackView.snp.makeConstraints {
            $0.top.equalTo(nameStackView.snp.bottom).offset(20)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.height.equalTo(100)
        }
        
        startingPointStackView.snp.makeConstraints {
            $0.top.equalTo(timeInTakeStackView.snp.bottom).offset(20)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.height.equalTo(120)
        }
        
        startingPointLabel.snp.makeConstraints {
            $0.height.equalTo(20)
        }
        
        startingPointTextView.snp.makeConstraints {
            $0.height.equalTo(30)
        }
        
        startingPointMapButton.snp.makeConstraints {
            $0.height.equalTo(30)
        }
        
        startingPointSearchButton.snp.makeConstraints {
            $0.height.equalTo(30)
        }
        
        destinationStackView.snp.makeConstraints {
            $0.top.equalTo(startingPointStackView.snp.bottom).offset(20)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.height.equalTo(120)
        }
        
        destinationLabel.snp.makeConstraints {
            $0.height.equalTo(20)
        }
        
        destinationTextView.snp.makeConstraints {
            $0.height.equalTo(30)
        }
        
        destinationMapButton.snp.makeConstraints {
            $0.height.equalTo(30)
        }
        
        destinationSearchButton.snp.makeConstraints {
            $0.height.equalTo(30)
        }
        
    }
}
