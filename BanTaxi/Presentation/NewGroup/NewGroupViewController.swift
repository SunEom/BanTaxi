//
//  NewGroupViewController.swift
//  BanTaxi
//
//  Created by 엄태양 on 2023/02/24.
//

import UIKit
import RxSwift
import RxCocoa

class NewGroupViewController: UIViewController {
    
    let disposeBag = DisposeBag()
    let viewModel: NewGroupViewModel!
    
    let scrollView = UIScrollView()
    let contentView = UIView()
    
    let saveButton = UIBarButtonItem(title: "저장", style: .done, target: nil, action: nil)
    
    let nameStackView = UIStackView()
    let nameLabel = UILabel()
    let nameTextField = UITextField()
    
    let startingPointStackView = UIStackView()
    let startingPointLabel = UILabel()
    let startingPointTextView = UITextView()
    let startingPointButton = UIButton()
    
    let destinationStackView = UIStackView()
    let destinationLabel = UILabel()
    let destinationTextView = UITextView()
    let destinationButton = UIButton()
    
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
    
    private func bind() {
        viewModel.intakeCount.bind(to: intakePicker.rx.itemTitles) { _, item in
            return "\(item)"
        }
        .disposed(by: disposeBag)
            
    }
    
    private func attribute() {
        title = "새 그룹 만들기"
        
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
        
        [startingPointButton, destinationButton].forEach {
            $0.setTitleColor(.white, for: .normal)
            $0.backgroundColor = UIColor(named: "MainColor")
            $0.layer.cornerRadius = 5
            $0.titleLabel?.font = .systemFont(ofSize: 15, weight: .semibold)
        }
        
        startingPointButton.setTitle( "출발지 설정", for: .normal)
        destinationButton.setTitle("도착지 설정", for: .normal)
        
        // DatePciker 속성
        timePicker.datePickerMode = .time
        timePicker.preferredDatePickerStyle = .wheels
        
    }
    
    private func layout() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        [nameStackView, startingPointStackView, destinationStackView, timeInTakeStackView].forEach { contentView.addSubview($0)}
        [timeStackView, intakeStackView].forEach { timeInTakeStackView.addArrangedSubview($0) }
        [nameLabel, nameTextField].forEach { nameStackView.addArrangedSubview($0) }
        [startingPointLabel, startingPointTextView, startingPointButton].forEach { startingPointStackView.addArrangedSubview($0) }
        [destinationLabel, destinationTextView, destinationButton].forEach { destinationStackView.addArrangedSubview($0) }
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
        
        startingPointButton.snp.makeConstraints {
            $0.height.equalTo(25)
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
        
        destinationButton.snp.makeConstraints {
            $0.height.equalTo(25)
        }
        
    }
}
