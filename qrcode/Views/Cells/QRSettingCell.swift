//
//  QRSettingCell.swift
//  qrcode
//
//  Created by Quang Tran on 2/9/21.
//

import UIKit
import RxSwift
import RxCocoa

class QRSettingCell: UITableViewCell {
    
    weak var separatorView: UIView!
    weak var iconImageView: UIImageView!
    weak var containerView: UIView!
    
    //sourcery:begin: superView = containerView
    weak var titleLabel: UILabel!
    weak var contentLabel: UILabel!
    //sourcery:end
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        createViews()
        setupViews()
        createConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    
    func setUp(_ viewModel: VMSettingTableCell) {
        iconImageView.image = UIImage(named: viewModel.iconName)
        titleLabel.text = viewModel.title
        contentLabel.text = viewModel.content
    }
}

extension QRSettingCell: CellAutoCreateViews {
    
    func setupViews() {
        
        backgroundColor = .clear
        selectionStyle = .none
        separatorView.backgroundColor = .seperatorColor
        
        iconImageView.backgroundColor = .clear
        iconImageView.contentMode = .scaleAspectFit
        
        titleLabel.textColor = .textColor
        titleLabel.font = UIFont.default.withSize(19)
        titleLabel.textAlignment = .left
        
        contentLabel.textColor = .secondaryTextColor
        contentLabel.font = UIFont.default.withSize(14)
        contentLabel.textAlignment = .left
        
    }
    
    func createConstraints() {
        
        let viewsDict = self.viewsDictionary
        
        var  constraints: [NSLayoutConstraint] = [
            NSLayoutConstraint.constraints(withVisualFormat: "H:|-[iconImageView]-30-[containerView]-|", options: [.alignAllCenterY], metrics: nil, views: viewsDict),
            NSLayoutConstraint.constraints(withVisualFormat: "V:|[containerView(>=50)]|", options: [], metrics: nil, views: viewsDict),
            NSLayoutConstraint.constraints(withVisualFormat: "V:|->=4-[titleLabel(20)]-4-[contentLabel(15)]->=4-|", options: [.alignAllLeading,.alignAllTrailing], metrics: nil, views: viewsDict),
            NSLayoutConstraint.constraints(withVisualFormat: "H:|[titleLabel]|", options: [], metrics: nil, views: viewsDict)
        ].flatMap{$0}
        
        constraints += separatorView.constraints(equalTo: self, attributes: [.bottom,.trailing])
        constraints += iconImageView.constraints(ratio: 1, width: 30)
        
        constraints.append(contentsOf: [
            iconImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: containerView.centerYAnchor),
            separatorView.heightAnchor.constraint(equalToConstant: 0.3),
            separatorView.leadingAnchor.constraint(equalTo: iconImageView.leadingAnchor)
        ])
        
        NSLayoutConstraint.activate(constraints)
        
    }
}

struct VMSettingTableCell {
    var iconName: String
    var title: String
    var content: String?
}

