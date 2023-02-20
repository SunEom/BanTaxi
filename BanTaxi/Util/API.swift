//
//  API.swift
//  BanTaxi
//
//  Created by 엄태양 on 2023/02/21.
//

import Foundation

extension Bundle {
    // 생성한 .plist 파일 경로 불러오기
        var Kakao_API_KEY: String {
            guard let file = self.path(forResource: "API-Key", ofType: "plist") else { return "" }
            
            // .plist를 딕셔너리로 받아오기
            guard let resource = NSDictionary(contentsOfFile: file) else { return "" }
            
            // 딕셔너리에서 값 찾기
            guard let key = resource["Kakao"] as? String else {
                fatalError("Kakao error")
            }
            return key
        }
}
