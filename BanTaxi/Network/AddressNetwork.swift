//
//  AddressRepository.swift
//  BanTaxi
//
//  Created by 엄태양 on 2023/02/27.
//

import Foundation
import RxAlamofire
import RxSwift

struct AddressNetwork {
    let disposeBag = DisposeBag()
    let session = URLSession.shared
    
    func requestAddressSearch(with keyword: String) -> Observable<[AddressData]> {
        let urlString = "https://dapi.kakao.com/v2/local/search/keyword.json?query=\(keyword)"
        let encodedString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let url = URL(string: encodedString)!
        
        return RxAlamofire.requestData(.get, url, headers: ["Authorization": "KakaoAK \(Bundle.main.Kakao_API_KEY)"])
            .map { (r, data) in
                do {
                    let decodedData = try JSONDecoder().decode(AddressResponseData.self, from: data)
                    var addressData = [AddressData]()
                    if decodedData.documents != nil {
                        addressData = decodedData.documents!.map {
                            AddressData(roadAddress: $0.roadAddress, jibunAddress: $0.jibunAddress, latitude: Double($0.latitudeStr ?? ""), longitude: Double($0.longitudeStr ?? ""), placeName: $0.placeName)
                        }
                    }
                    return addressData
                } catch {
                    return []
                }
            }
    }
}
