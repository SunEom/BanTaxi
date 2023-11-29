//
//  MyGroupViewController.swift
//  BanTaxi
//
//  Created by 엄태양 on 2023/03/06.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import NVActivityIndicatorView

class MyGroupViewController: UIViewController {
    private let disposeBag = DisposeBag()
    private let viewModel: MyGroupViewModel
    
    private let tableView = UITableView()
    
    private let activityIndicator = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: K.ScreenSize.width, height: K.ScreenSize.height), type: .circleStrokeSpin, color: K.Color.mainColor, padding: 200)
    
    init(viewModel: MyGroupViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(GroupListCellViewController.self, forCellReuseIdentifier: K.TableViewCellID.GroupListCell)
        
        bind()
        attribute()
        layout()
    }
    
    private func bind() {
        
        let viewWillAppear = rx.sentMessage(#selector(UIViewController.viewWillAppear(_:))).map { _ in () }.asDriver(onErrorJustReturn: ())
        
        let input = MyGroupViewModel.Input(trigger: viewWillAppear, select: tableView.rx.itemSelected.asDriver())
        
        let output = viewModel.transform(input: input)
        
        output.loading
            .drive(onNext: { loading in
                if loading {
                    self.activityIndicator.startAnimating()
                    self.activityIndicator.isHidden = false
                } else {
                    self.activityIndicator.stopAnimating()
                    self.activityIndicator.isHidden = true
                }
            })
            .disposed(by: disposeBag)
            
        
        output.groups
            .drive(tableView.rx.items) { tv, row, item in
                let cell = tv.dequeueReusableCell(withIdentifier: K.TableViewCellID.GroupListCell) as! GroupListCellViewController
                cell.setUp(with: item)
                return cell
            }
            .disposed(by: disposeBag)
        
        output.selectedGroup
            .drive(onNext: {[weak self] groupInfo in
                self?.navigationController?.pushViewController(GroupDetailViewController(with: groupInfo), animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    private func attribute() {
        view.backgroundColor = .white
        title = "내 그룹"
        self.navigationController?.navigationBar.topItem?.title = " "
    }
    
    private func layout() {
        
        [tableView, activityIndicator].forEach { view.addSubview($0) }
        
        activityIndicator.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        tableView.snp.makeConstraints {
            $0.top.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
        }
        
    }
}
