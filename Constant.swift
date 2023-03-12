//
//  Constant.swift
//  BanTaxi
//
//  Created by 엄태양 on 2023/02/26.
//

import Foundation

struct K {
    struct Color {
        static let mainColor = UIColor(named: "MainColor")
    }
    
    struct TableViewCellID {
        static let AddressSearchCell = "AddressSearchCell"
        static let GroupListCell = "GroupListCell"
        static let ChatBubbleCell = "ChatBubbleCell"
    }
    
    struct ScreenSize {
        static let width = UIScreen.main.bounds.width
        static let height = UIScreen.main.bounds.height
    }
}
