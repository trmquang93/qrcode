//
//  UIFont+Fonts.swift
//  qrcode
//
//  Created by Quang Tran on 2/6/21.
//

import UIKit

extension UIFont {
    static var defaultFontSize: CGFloat = UIFont.systemFontSize
    
    static var `default`: UIFont {
        return UIFont(name: "Helvetica", size: defaultFontSize) ?? .systemFont(ofSize: defaultFontSize)
    }
    
    static var bold: UIFont {
        return UIFont(name: "Helvetica-Bold", size: 18) ?? .systemFont(ofSize: 18, weight: .bold)
    }
    
    static var italic: UIFont {
        return UIFont(name: "Helvetica-Oblique", size: 18) ?? .italicSystemFont(ofSize: 18)
    }
}
