//
//  MyGroupViewModel.swift
//  BanTaxi
//
//  Created by 엄태양 on 2023/03/06.
//

import Foundation
import RxSwift
import RxRelay

struct MyGroupViewModel {
    let disposeBag = DisposeBag()
    
    let list = Observable.just([GroupInfo(name: "새로운 그룹1", time: Date(), intake: 3, start: AddressData(roadAddress: "양천구 목동대로 123", jibunAddress: "양천구 목2동", latitude: nil, longitude: nil, placeName: "목동 중학교"), destination: AddressData(roadAddress: "서울시 종로구 ", jibunAddress: "서울시 종로구", latitude: nil, longitude: nil, placeName: ""), hostUid: "asdfasdfasdfasdf"), GroupInfo(name: "새로운 그룹2", time: Date(), intake: 3, start: AddressData(roadAddress: "양천구 목동대로 123", jibunAddress: "양천구 목2동", latitude: nil, longitude: nil, placeName: "목동 중학교"), destination: AddressData(roadAddress: "서울시 종로구 123 123 123 123 123 ", jibunAddress: "서울시 종로구 123 123 123 123 123", latitude: nil, longitude: nil, placeName: ""), hostUid: "asdfasdfasdfasdf"),GroupInfo(name: "새로운 그룹3", time: Date(), intake: 3, start: AddressData(roadAddress: "양천구 목동대로 123", jibunAddress: "양천구 목2동", latitude: nil, longitude: nil, placeName: "목동 중학교"), destination: AddressData(roadAddress: "서울시 종로구 ", jibunAddress: "서울시 종로구", latitude: nil, longitude: nil, placeName: ""), hostUid: "asdfasdfasdfasdf")])
    
}
