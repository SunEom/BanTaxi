//
//  AddressSearchViewModel.swift
//  BanTaxi
//
//  Created by 엄태양 on 2023/02/25.
//

import Foundation
import RxRelay
import RxSwift

struct AddressSearchViewModel {
    let diseposBag = DisposeBag()
    let searchResults = PublishRelay<[AddressData]?>()
    let keyword = PublishRelay<String>()
    let searchButtonTap = PublishRelay<Void>()
    
    init(_ repo: AddressRepository = AddressRepository()) {
        searchButtonTap
            .withLatestFrom(keyword)
            .flatMapLatest(repo.searchWithKeyword(with:))
            .bind(to: searchResults)
            .disposed(by: diseposBag)
    }
}
