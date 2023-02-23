//
//  QRHistoryCell.swift
//  qrcode
//
//  Created by Quang Tran on 2/8/21.
//

import UIKit
import AppStarter
import RxSwift

class QRHistoryCell: UITableViewCell {
    weak var menuStackView: UIStackView!
    
    //sourcery:begin: superView = menuStackView, stackView
    weak var contentStackView: UIStackView!
    weak var menuView: QRCellMenuView!
    //sourcery:end
    
    //sourcery:begin: superView = contentStackView, stackView
    weak var selectionView: UIImageView!
    weak var itemIcon: UIImageView!
    weak var textContainer: UIView!
    weak var accessoryContainerView: UIButton!
    //sourcery:end
    
    //sourcery:begin: superView = textContainer
    weak var titleLabel: UILabel!
    weak var dateLabel: UILabel!
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
    
    func setSelecting(_ isSelecting: Bool) {
        let imageName = isSelecting ? "selection_true_ic" : "selection_empty_ic"
        selectionView.image = UIImage(named: imageName)?.withRenderingMode(.alwaysOriginal)
    }
    
    func setEnableSelection(_ enable: Bool, animated: Bool) {
        if animated {
            UIView.animate(withDuration: 0.2) {[weak self] in
                self?.selectionView.isHidden = !enable
                self?.accessoryContainerView.isHidden = enable
            } completion: { [weak self] finished in
                self?.selectionView.isHidden = !enable
                self?.accessoryContainerView.isHidden = enable
            }
        } else {
            selectionView.isHidden = !enable
            accessoryContainerView.isHidden = enable
        }

    }
    
    func setEnableMenu(_ enable: Bool, animated: Bool) {
        if animated {
            UIView.animate(withDuration: 0.2) {[weak self] in
                self?.menuView.isHidden = !enable
            } completion: { [weak self] finished in
                self?.menuView.isHidden = !enable
            }

        } else {
            menuView.isHidden = !enable
        }
    }

    func addMenu(_ uiView: UIView) {
        uiView.removeFromSuperview()
        menuView.subviews(uiView)
        uiView.fillContainer()
    }
}

extension QRHistoryCell: CellAutoCreateViews {
    func setupViews() {
        separatorInset = UIEdgeInsets(top: 0, left: 40, bottom: 0, right: 0)
        
        menuStackView.style {
            $0.axis = .vertical
            $0.spacing = 10
        }
        
        contentStackView.style {
            $0.axis = .horizontal
            $0.spacing = 10
        }
        
        selectionView.style {
            $0.contentMode = .scaleAspectFit
            $0.isHidden = true
        }
        
        itemIcon.style {
            $0.contentMode = .scaleAspectFit
            $0.tintColor = .tintColor
        }
        
        titleLabel.style {
            $0.font = UIFont.bold.withSize(14)
        }
        
        dateLabel.style {
            $0.font = UIFont.default.withSize(13)
            $0.textColor = .secondaryTextColor
        }
        
        accessoryContainerView.style  {
            $0.contentEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
            $0.setImage(UIImage(named: "history_cell_accessory_ic")?.withRenderingMode(.alwaysOriginal), for: .normal)
        }
        
        clipsToBounds = true
        menuView.isHidden = true
    }
    
    func createConstraints() {
        menuStackView
            .leading(20)
            .trailing(10)
            .top(10)
            .bottom(>=10)
        
        textContainer.layout {
            0
            |titleLabel| ~ 20
            |dateLabel| ~ 20
            0
        }
        
        selectionView
            .width(20)
            .centerVertically()
        
        itemIcon
            .fillVertically()
            .width(25)
        
        accessoryContainerView
            .width(25)
            .fillVertically()
        
        menuView
            .height(70)
    }
}
