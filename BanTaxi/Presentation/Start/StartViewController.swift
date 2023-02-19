//
//  StartViewController.swift
//  BanTaxi
//
//  Created by 엄태양 on 2023/02/19.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

class StartViewController: UIViewController {
    let disposeBag = DisposeBag()
    let titleLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        attribute()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let vc = LoginViewController()
        vc.modalPresentationStyle = .fullScreen
        vc.modalTransitionStyle = .crossDissolve
        present(vc, animated: true)
    }
    
    private func attribute() {
        
        view.backgroundColor = UIColor(named: "MainColor")
        titleLabel.textColor = .white
        titleLabel.text = "BanTaxi"
        titleLabel.font = .systemFont(ofSize: 36, weight: .bold)
        
    }
    
    private func layout() {
        [titleLabel].forEach { view.addSubview($0) }
        
        titleLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
}
