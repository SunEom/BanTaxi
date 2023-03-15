//
//  NicknameEditViewController.swift
//  BanTaxi
//
//  Created by 엄태양 on 2023/03/14.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import NVActivityIndicatorView

class NicknameEditViewController: UIViewController {
    let disposeBag = DisposeBag()
    let viewModel: NicknameEditViewModel
    
    let activityIndicator = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: K.ScreenSize.width, height: K.ScreenSize.height), type: .circleStrokeSpin, color: K.Color.mainColor, padding: 200)
    
    let titleLabel = UILabel()
    let inputTextField = UITextField()
    let divider = UIView()
    
    let saveButton = UIBarButtonItem(title: "저장", style: .done, target: nil, action: nil)
    
    init(){
        viewModel = NicknameEditViewModel()
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
        
        inputTextField.rx.text
            .orEmpty
            .bind(to: viewModel.input)
            .disposed(by: disposeBag)
        
        viewModel.nicknameEditResult
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { result in
                if result.isSuccess {
                    self.navigationController?.popViewController(animated: true)
                } else {
                    let alert = UIAlertController(title: "오류", message: result.msg == "이미 사용중인 닉네임입니다." ? "이미 사용중인 닉네임입니다." : "오류가 발생했습니다.\n잠시후에 다시 시도해주세요.", preferredStyle: .alert)
                    let action = UIAlertAction(title: "확인", style: .default)
                    alert.addAction(action)
                    self.present(alert, animated: true)
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func attribute() {
        view.backgroundColor = .white
        
        navigationItem.rightBarButtonItem = saveButton
        navigationItem.rightBarButtonItem?.tintColor = K.Color.mainColor
        
        title = "닉네임 수정"
        
        titleLabel.text = "닉네임"
        titleLabel.font = .systemFont(ofSize: 13, weight: .bold)
        titleLabel.textColor = .gray
        
        inputTextField.font = .systemFont(ofSize: 18, weight: .semibold)
        
        divider.backgroundColor = .lightGray
        
    }
    
    private func layout() {
        [titleLabel, inputTextField, divider, activityIndicator].forEach { view.addSubview($0) }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            $0.leading.equalTo(view.safeAreaLayoutGuide).offset(15)
            $0.trailing.equalTo(view.safeAreaLayoutGuide).offset(-15)
        }
        
        inputTextField.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(5)
            $0.leading.trailing.equalTo(titleLabel)
        }
        
        divider.snp.makeConstraints {
            $0.top.equalTo(inputTextField.snp.bottom).offset(10)
            $0.leading.trailing.equalTo(inputTextField)
            $0.height.equalTo(1)
        }
    }
}
