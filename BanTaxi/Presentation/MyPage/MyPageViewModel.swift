//
//  MyPageViewModel.swift
//  BanTaxi
//
//  Created by 엄태양 on 2023/03/03.
//

import Foundation
import RxSwift
import RxCocoa

struct MyPageViewModel {
    private let disposeBag = DisposeBag()
    
    struct Input {
        let trigger: Driver<Void>
    }
    
    struct Output {
        let user: Driver<User?>
    }
    
    func transform(input: Input) -> Output {
        input.trigger
            .drive(onNext: {
                UserManager.logout()
            })
            .disposed(by: disposeBag)
        
        return Output(user: UserManager.getInstance().asDriver(onErrorJustReturn: nil))
    }
}
