//
//  QRLookupItemCell.swift
//  qrcode
//
//  Created by Quang Tran on 2/19/21.
//

import UIKit

class QRLookupItemCell: UICollectionViewCell {
    weak var imageView: UIImageView!
    
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

extension QRLookupItemCell: CellAutoCreateViews {
    func setupViews() {
        imageView.style {
            $0.contentMode = .scaleAspectFit
        }
        
        contentView.style {
            $0.backgroundColor = .textBackgroundColor
            $0.layer.cornerRadius = 5
        }
    }
    
    func createConstraints() {
        imageView
            .fillContainer(padding: 10)
    }
}
