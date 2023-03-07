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

class MyGroupViewController: UIViewController {
    let disposeBag = DisposeBag()
    let viewModel: MyGroupViewModel!
    
    let tableView = UITableView()
    
    init() {
        viewModel = MyGroupViewModel()
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
        viewModel.list
            .bind(to: tableView.rx.items) { tv, row, item in
                let cell = tv.dequeueReusableCell(withIdentifier: K.TableViewCellID.GroupListCell) as! GroupListCellViewController
                cell.setUp(with: item)
                return cell
            }
            .disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .map { indexPath in
                self.tableView.cellForRow(at: indexPath)?.isSelected = false
                return indexPath.row
            }
            .withLatestFrom(viewModel.list) { idx, list in return list[idx] }
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { groupInfo in
                self.navigationController?.pushViewController(GroupDetailViewController(with: groupInfo), animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    private func attribute() {
        view.backgroundColor = .white
        title = "내 그룹"
        self.navigationController?.navigationBar.topItem?.title = " "
    }
    
    private func layout() {
        
        [tableView].forEach { view.addSubview($0) }
        
        tableView.snp.makeConstraints {
            $0.top.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
        }
        
    }
}
