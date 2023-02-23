//
//  DefaultButton.swift
//  qrcode
//
//  Created by Quang Tran on 2/8/21.
//

import UIKit

class DefaultButton: UIButton {
    
    override var isHighlighted: Bool {
        set {
            super.isSelected = newValue
            alpha = newValue ? 0.5 : 1
        }
        get {
            return super.isSelected
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        style {
            $0.backgroundColor = .tintColor
            $0.layer.cornerRadius = 10
            $0.setTitleColor(.textColor, for: .normal)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setTitle(_ title: String?, for state: UIControl.State) {
        if state == .normal {
            let attributedTitle = title.map({NSAttributedString(string: $0, attributes: [.font : UIFont.bold, .foregroundColor: UIColor.buttonTextColor])})
            
            setAttributedTitle(attributedTitle, for: state)
        } else {
            super.setTitle(title, for: state)
        }
    }
}
