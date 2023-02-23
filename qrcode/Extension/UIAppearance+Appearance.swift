//
//  UIAppearance+Appearance.swift
//  qrcode
//
//  Created by Quang Tran on 2/6/21.
//

import UIKit

extension UIView {
    static func setupAppearance() {
        let navigationBar = UINavigationBar.appearance()
        navigationBar.barTintColor = .backgroundColor
        navigationBar.tintColor = .tintColor
        navigationBar.titleTextAttributes = [
            .foregroundColor: UIColor.tintColor,
            .font: UIFont.bold
        ]
        
        let tabbar = UITabBar.appearance()
        tabbar.tintColor = .tintColor
        tabbar.barTintColor = .backgroundColor
        
        let barItem = UIBarButtonItem.appearance()
        barItem.tintColor = .tintColor
        
        let textField = UITextField.appearance()
        textField.textColor = .textColor
    }
}
