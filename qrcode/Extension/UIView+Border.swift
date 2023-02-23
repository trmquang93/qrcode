//
//  UIView+Border.swift
//  qrcode
//
//  Created by Quang Tran on 2/7/21.
//

import UIKit

extension UIView {
    func addTopBorderWithColor(color: UIColor = .seperatorColor, thickness: CGFloat) {
        let border = UIView()
        border.backgroundColor = color
        border.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(border)
        border
            .top(0)
            .leading(0)
            .trailing(0)
            .height(thickness)
    }
    
    func addRightBorderWithColor(color: UIColor = .seperatorColor, thickness: CGFloat) {
        let border = UIView()
        border.backgroundColor = color
        border.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(border)
        border
            .top(0)
            .bottom(0)
            .leading(0)
            .width(thickness)
    }
    
    func addBottomBorderWithColor(color: UIColor = .seperatorColor, thickness: CGFloat) {
        let border = UIView()
        border.backgroundColor = color
        border.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(border)
        border
            .leading(0)
            .bottom(0)
            .trailing(0)
            .height(thickness)
    }
    
    func addLeftBorderWithColor(color: UIColor = .seperatorColor, thickness: CGFloat) {
        let border = UIView()
        border.backgroundColor = color
        border.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(border)
        border
            .top(0)
            .bottom(0)
            .leading(0)
            .width(thickness)
    }
}
