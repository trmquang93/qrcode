//
//  TextScrollView.swift
//  qrcode
//
//  Created by Quang Tran on 2/19/21.
//

import UIKit
import AppStarter

class TextScrollView: UIScrollView {
    weak var textView: TextViewWithPlaceholder!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        createViews()
        setupViews()
        createConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension TextScrollView: AutoCreateViews {
    func setupViews() {
        textView.style {
            $0.isScrollEnabled = false
            $0.textContainer.maximumNumberOfLines = 1
            $0.isEditable = false
            $0.font = UIFont.default.withSize(18)
            $0.backgroundColor = .clear
        }
        
        textView.rx.text.subscribe(onNext: {[weak self] text in
            guard let `self` = self else { return }
            let contentSize = self.contentSize
            let conetntOffset = contentSize.width - self.frame.width
            self.setContentOffset(CGPoint(x: max(10, conetntOffset), y: 0), animated: true)
        }).disposed(by: disposeBag)
        
        self.style {
            $0.backgroundColor = .textBackgroundColor
            $0.layer.cornerRadius = 10
        }
    }
    
    func createConstraints() {
        textView
            .centerVertically()
            .fillHorizontally(padding: 10)
        
        textView.make {
            $0.widthAnchor.constraint(greaterThanOrEqualTo: self.widthAnchor, constant: -20)
        }
    }
}
