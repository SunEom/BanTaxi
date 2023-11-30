//
//  AddressSearchViewController.swift
//  BanTaxi
//
//  Created by 엄태양 on 2023/02/25.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import NVActivityIndicatorView

class AddressSearchViewController: UIViewController {
    private let disposeBag = DisposeBag()
    private let viewModel : AddressSearchViewModel
    
    private let activityIndicator = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: K.ScreenSize.width, height: K.ScreenSize.height), type: .circleStrokeSpin, color: K.Color.mainColor, padding: 200)
    private let topView = UIView()
    private let keywordTextField = UITextField()
    private let underLine = UIView()
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(AddressSearchViewCell.self, forCellReuseIdentifier: K.TableViewCellID.AddressSearchCell)
        return tableView
    }()
    
    init(viewModel: AddressSearchViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind()
        uiEvent()
        attribute()
        layout()
    }
    
    private func bind() {
        
        let input = AddressSearchViewModel.Input(keyword: keywordTextField.rx.text.orEmpty.asDriver(),
                                                 searchTrigger: keywordTextField.rx.controlEvent(.editingDidEndOnExit).asDriver(),
                                                 saveTrigger: tableView.rx.itemSelected.asDriver())
        
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
        
        output.result
            .drive(tableView.rx.items) { tv, row, result in
                let cell = self.tableView.dequeueReusableCell(withIdentifier: K.TableViewCellID.AddressSearchCell, for: IndexPath(row: row, section: 0)) as! AddressSearchViewCell
                cell.setUp(with: AddressSearchViewCellViewModel(addressSearchResult: result))
                return cell
            }
            .disposed(by: disposeBag)
    }
    
    private func uiEvent() {
        tableView.rx.itemSelected
            .asDriver()
            .drive(onNext: {[weak self] _ in
                self?.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    private func attribute() {
        view.backgroundColor = .white
        view.addTapGesture(cancelsTouchesInViewOption: false)
        
        self.navigationController?.navigationBar.topItem?.title = " "
        self.navigationController?.navigationBar.tintColor = .white
        
        topView.backgroundColor = UIColor(named: "MainColor")
        
        keywordTextField.attributedPlaceholder = NSAttributedString(string: "검색어를 입력해주세요.", attributes: [NSAttributedString.Key.foregroundColor : UIColor(white: 0.8, alpha: 1)])
        keywordTextField.tintColor = .white
        keywordTextField.textColor = .white
        keywordTextField.font = .systemFont(ofSize: 23, weight: .semibold)
        keywordTextField.returnKeyType = .search
        underLine.backgroundColor = UIColor(white: 0.8, alpha: 1)

    }
    
    private func layout() {
        [topView, tableView, activityIndicator].forEach { view.addSubview($0) }
        
        [keywordTextField, underLine].forEach { topView.addSubview($0) }
        
        activityIndicator.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalTo(tableView)
        }
        
        topView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(200)
        }
        
        keywordTextField.snp.makeConstraints {
            $0.leading.equalTo(topView).offset(40)
            $0.trailing.equalTo(topView).offset(-40)
            $0.centerY.equalTo(topView).offset(25)
            $0.height.equalTo(60)
        }
        
        underLine.snp.makeConstraints {
            $0.top.equalTo(keywordTextField.snp.bottom).offset(-5)
            $0.leading.trailing.equalTo(keywordTextField)
            $0.height.equalTo(1)
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(topView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        
    }
}
