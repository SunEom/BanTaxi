//
//  UITextField.swift
//  BanTaxi
//
//  Created by 엄태양 on 2023/02/27.
//

import Foundation

extension UITextField {
    func addLeftPadding() {
        self.leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 10.0, height: 0.0))
        self.leftViewMode = .always
    }
}
