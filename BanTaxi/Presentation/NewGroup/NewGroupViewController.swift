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
    
    let disposeBag = DisposeBag()
    let viewModel: NewGroupViewModel!
    
    let activityIndicator = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: K.ScreenSize.width, height: K.ScreenSize.height), type: .circleStrokeSpin, color: K.Color.mainColor, padding: 200)
    
    let scrollView = UIScrollView()
    let contentView = UIView()
    
    let saveButton = UIBarButtonItem(title: "저장", style: .done, target: nil, action: nil)
    
    let nameStackView = UIStackView()
    let nameLabel = UILabel()
    let nameTextField = UITextField()
    
    let startingPointStackView = UIStackView()
    let startingPointLabel = UILabel()
    let startingPointTextView = UITextView()
    let startingPointButtonStackView = UIStackView()
    let startingPointMapButton = UIButton()
    let startingPointSearchButton = UIButton()
    
    let destinationStackView = UIStackView()
    let destinationLabel = UILabel()
    let destinationTextView = UITextView()
    let destinationButtonStackView = UIStackView()
    let destinationMapButton = UIButton()
    let destinationSearchButton = UIButton()
    
    let timeInTakeStackView = UIStackView()
    
    let timeStackView = UIStackView()
    let timeLabel = UILabel()
    let timePicker = UIDatePicker()
    
    let intakeStackView = UIStackView()
    let intakeLabel = UILabel()
    let intakePicker = UIPickerView()
    
    init() {
        viewModel = NewGroupViewModel()
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
        
        saveButton.rx.tap
            .bind(to: viewModel.saveButtonTap)
            .disposed(by: disposeBag)
        
        nameTextField.rx.text
            .orEmpty
            .bind(to: viewModel.groupName)
            .disposed(by: disposeBag)
        
        timePicker.rx.controlEvent(.valueChanged)
            .map { self.timePicker.date < Date.now ? 1.days.later(than: self.timePicker.date) : self.timePicker.date }
            .bind(to: viewModel.time)
            .disposed(by: disposeBag)
        
        intakePicker.rx.itemSelected
            .map { $0.row }
            .bind(to: viewModel.intakeIndex)
            .disposed(by: disposeBag)
        
        viewModel.intakeCountList.bind(to: intakePicker.rx.itemTitles) { _, item in
            return "\(item)"
        }
        .disposed(by: disposeBag)
        
        startingPointMapButton.rx.tap
            .asDriver()
            .drive(onNext: {
                self.navigationController?.pushViewController(LocationSelectViewController(mode: .Starting, with: self.viewModel.startingPoint), animated: true)
            })
            .disposed(by: disposeBag)
        
        destinationMapButton.rx.tap
            .asDriver()
            .drive(onNext: {
                self.navigationController?.pushViewController(LocationSelectViewController(mode: .Destination, with: self.viewModel.destinationPoint), animated: true)
            })
            .disposed(by: disposeBag)
        
        startingPointSearchButton.rx.tap
            .asDriver()
            .drive(onNext:  {
                self.navigationController?.pushViewController(AddressSearchViewController(mode: .Starting, with: self.viewModel.startingPoint), animated: true)
            })
            .disposed(by: disposeBag)
        
        destinationSearchButton.rx.tap
            .asDriver()
            .drive(onNext:  {
                self.navigationController?.pushViewController(AddressSearchViewController(mode: .Destination,with: self.viewModel.destinationPoint), animated: true)
            })
            .disposed(by: disposeBag)
            
        viewModel.startingPoint
            .map { $0?.roadAddress ?? "아직 선택된 출발지가 없습니다" }
            .bind(to: startingPointTextView.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.destinationPoint
            .map { $0?.roadAddress ?? "아직 선택된 도착지가 없습니다" }
            .bind(to: destinationTextView.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.requestResult
            .observe(on: MainScheduler.instance)
            .subscribe(onNext:{ result in
                if result.isSuccess {
                    let alert = UIAlertController(title: "성공", message: "새로운 그룹을 만들었습니다.", preferredStyle: .alert)
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
    }
    
    private func attribute() {
        
        view.addTapGesture()
        view.backgroundColor = UIColor(white: 0.95, alpha: 1)
        navigationItem.rightBarButtonItem = saveButton
        
        // StackView 속성
        [nameStackView, startingPointStackView, destinationStackView, timeStackView, intakeStackView].forEach {
            $0.axis = .vertical
            $0.spacing = 5
            $0.backgroundColor = .white
            $0.layer.cornerRadius = 10
            $0.layoutMargins = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
            $0.isLayoutMarginsRelativeArrangement = true
            $0.distribution = .equalSpacing
        }
        
        timeInTakeStackView.axis = .horizontal
        timeInTakeStackView.spacing = 10
        
        [startingPointButtonStackView, destinationButtonStackView].forEach {
            $0.axis = .horizontal
            $0.distribution = .fillEqually
            $0.spacing = 10
        }
        
        // Label 속성
        [nameLabel, startingPointLabel, destinationLabel, timeLabel, intakeLabel].forEach {
            $0.font = .systemFont(ofSize: 11, weight: .bold)
            $0.textColor = .gray
        }
        
        nameLabel.text = "그룹 이름"
        startingPointLabel.text = "출발지"
        destinationLabel.text = "도착지"
        timeLabel.text = "예정 시각"
        intakeLabel.text = "모집인원 (본인 포함)"
        
        // TextField 속성
        [nameTextField].forEach {
            $0.backgroundColor = .white
        }
        
        nameTextField.placeholder = "그룹 이름 입력"
    
        // TextView 속성
        [startingPointTextView, destinationTextView].forEach {
            $0.isEditable = false
        }
        
        startingPointTextView.text = "아직 선택된 출발지가 없습니다"
        destinationTextView.text = "아직 선택된 도착지가 없습니다"
        
        // Button 속성
        
        [startingPointMapButton, startingPointSearchButton, destinationMapButton, destinationSearchButton].forEach {
            $0.setTitleColor(.white, for: .normal)
            $0.backgroundColor = UIColor(named: "MainColor")
            $0.layer.cornerRadius = 5
            $0.titleLabel?.font = .systemFont(ofSize: 15, weight: .semibold)
        }
        
        
        startingPointMapButton.setTitle( "지도에서 찾기", for: .normal)
        destinationMapButton.setTitle("지도에서 찾기", for: .normal)
        
        startingPointSearchButton.setTitle( "주소 검색하기", for: .normal)
        destinationSearchButton.setTitle("주소 검색하기", for: .normal)
        
        // DatePciker 속성
        timePicker.datePickerMode = .time
        timePicker.preferredDatePickerStyle = .wheels
        timePicker.locale = Locale(identifier: "ko-KR")
        timePicker.setDate(Date.now, animated: true)
        
        
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
        
        nameTextField.snp.makeConstraints {
            $0.height.equalTo(30)
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
