//
//  CenteredVerticalTextView.swift
//  qrcode
//
//  Created by Quang Tran on 2/7/21.
//

import UIKit

class CenteredVerticalTextView: TextViewWithPlaceholder {
    override func layoutSubviews() {
        let contentSize = self.sizeThatFits(CGSize(width: bounds.width, height: .greatestFiniteMagnitude))
        
        var topCorrection = (bounds.size.height - contentSize.height * zoomScale)
        topCorrection = max(0, topCorrection)
        contentInset = UIEdgeInsets(top: topCorrection, left: 0, bottom: 0, right: 0)
        textContainerInset = UIEdgeInsets(top: topCorrection, left: 0, bottom: 0, right: 0)
    }
}
