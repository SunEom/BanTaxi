//
//  NicknameEditViewModel.swift
//  BanTaxi
//
//  Created by 엄태양 on 2023/03/14.
//

import Foundation
import RxSwift
import RxRelay

struct NicknameEditViewModel {
    let disposeBag = DisposeBag()
    let isLoading = BehaviorSubject(value: false)
    let input = PublishSubject<String>()
    let saveButtonTap = PublishRelay<Void>()
    let nicknameEditResult = PublishSubject<RequestResult>()
    
    init(_ repo: UserRepository = UserRepository()) {
        
        saveButtonTap
            .map { _ in return true }
            .bind(to: isLoading)
            .disposed(by: disposeBag)
        
        nicknameEditResult
            .map { _ in return false}
            .bind(to: isLoading)
            .disposed(by: disposeBag)
        
        saveButtonTap
            .withLatestFrom(input)
            .flatMapLatest(repo.updateNickname(with:))
            .bind(to:nicknameEditResult)
            .disposed(by: disposeBag)
            
    }
}
