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

class AddressSearchViewController: UIViewController {
    let diseposeBag = DisposeBag()
    let viewModel : AddressSearchViewModel!
    
    let newGroupViewModel: NewGroupViewModel!
    let mode: LocationSettingMode!
    
    let topView = UIView()
    let keywordTextField = UITextField()
    let underLine = UIView()
    let tableView = UITableView()
    
    init(mode: LocationSettingMode, with newGroupViewModel: NewGroupViewModel) {
        self.newGroupViewModel = newGroupViewModel
        self.mode = mode
        viewModel = AddressSearchViewModel()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(AddressSearchViewCell.self, forCellReuseIdentifier: K.TableViewCellID.AddressSearchCell)
        
        bind()
        attribute()
        layout()
    }
    
    private func bind() {
        
        viewModel.searchResults
            .asDriver(onErrorJustReturn: [])
            .map { $0 == nil ? [] : $0! }
            .drive(tableView.rx.items) { tv, row, result in
                let cell = self.tableView.dequeueReusableCell(withIdentifier: K.TableViewCellID.AddressSearchCell, for: IndexPath(row: row, section: 0)) as! AddressSearchViewCell
                
                cell.setUp(with: AddressSearchViewCellViewModel(addressSearchResult: result))
                
                return cell
            }
            .disposed(by: diseposeBag)
        
        tableView.rx.itemSelected
            .map { indexPath in
                self.tableView.cellForRow(at: indexPath)?.isSelected = false
                return indexPath.row
            }
            .withLatestFrom(viewModel.searchResults) { row, results in
                return results![row]
            }
            .subscribe {
                self.navigationController?.popViewController(animated: true)
                switch self.mode {
                    case .Starting:
                        self.newGroupViewModel.startingPoint.accept($0)
                    case .Destination:
                        self.newGroupViewModel.destinationPoint.accept($0)
                    default:break
                }
            }
            .disposed(by: diseposeBag)
            
        keywordTextField.rx.text
            .orEmpty
            .bind(to: viewModel.keyword)
            .disposed(by: diseposeBag)
        
        keywordTextField.rx.controlEvent(.editingDidEndOnExit)
            .bind(to: viewModel.searchButtonTap)
            .disposed(by: diseposeBag)
    }
    
    private func attribute() {
        view.backgroundColor = .white
        view.addTapGesture()
        
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
        [topView, tableView].forEach { view.addSubview($0) }
        
        [keywordTextField, underLine].forEach { topView.addSubview($0) }
        
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
