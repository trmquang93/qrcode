//
//  QRCreateCodeCell.swift
//  qrcode
//
//  Created by Quang Tran on 2/10/21.
//

import UIKit
import AppStarter

class QRCreateCodeCell: UICollectionViewCell {
    weak var container: UIView!
    
    //sourcery:begin: superView = container
    weak var iconView: UIImageView!
    weak var nameLabel: UILabel!
    //sourcery:end
    
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

extension QRCreateCodeCell: CellAutoCreateViews {
    func setupViews() {
        contentView.layer.cornerRadius = 5

        iconView.style {
            $0.contentMode = .scaleAspectFit
        }
        
        nameLabel.style {
            $0.textAlignment = .center
            $0.font = UIFont.bold.withSize(16)
        }
    }
    
    func createConstraints() {
        container
            .centerVertically()
            .centerHorizontally()
        
        contentView.layout {
            >=0
            |container|
            >=0
        }
        
        iconView
            .heightEqualsWidth()
            .centerHorizontally()
        
        nameLabel
            .height(20)
        
        container.layout {
            0
            |-(>=0)-iconView-(>=0)-| ~ 40
            |nameLabel| ~ 20
            0
        }
        
    }
}
