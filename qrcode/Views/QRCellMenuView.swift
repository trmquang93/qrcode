//
//  QRCellMenuView.swift
//  qrcode
//
//  Created by Quang Tran on 2/9/21.
//

import UIKit
import AppStarter

class QRCellMenuView: UIView {
    weak var contentStackView: UIStackView!
    
    //sourcery:begin: superView = contentStackView, stackView
    weak var copyView: UIView!
    weak var openView: UIView!
    weak var deleteView: UIView!
    //sourcery:end
    
    //sourcery:begin: superView = copyView
    weak var copyButton: UIButton!
    weak var copyButtonTitle: UILabel!
    //sourcery:end
    
    //sourcery:begin: superView = openView
    weak var openButton: UIButton!
    weak var openButtonTitle: UILabel!
    //sourcery:end
    
    //sourcery:begin: superView = deleteView
    weak var deleteButton: UIButton!
    weak var deleteButtonTitle: UILabel!
    //sourcery:end
    
    init() {
        super.init(frame: .zero)
        
        createViews()
        setupViews()
        createConstraints()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension QRCellMenuView: AutoCreateViews {
    func setupViews() {
        contentStackView.style {
            $0.axis = .horizontal
            $0.spacing = 10
        }
        
        copyButton.style {
            $0.setImage(UIImage(named: "menu_copy_ic")?.withRenderingMode(.alwaysOriginal), for: .normal)
        }
        
        openButton.style {
            $0.setImage(UIImage(named: "menu_open_ic")?.withRenderingMode(.alwaysOriginal), for: .normal)
        }
        
        deleteButton.style {
            $0.setImage(UIImage(named: "menu_delete_ic")?.withRenderingMode(.alwaysOriginal), for: .normal)
        }
        
        copyButtonTitle.style {
            $0.text = "copy_button".localized
            $0.font = .default
            $0.textAlignment = .center
        }
        
        openButtonTitle.style {
            $0.text = "open_button".localized
            $0.font = .default
            $0.textAlignment = .center
        }
        
        deleteButtonTitle.style {
            $0.text = "delete_button".localized
            $0.font = .default
            $0.textAlignment = .center
        }
    }
    
    func createConstraints() {
        contentStackView
            .leading(0)
            .trailing(>=0)
            .fillVertically()
        
        copyView
            .width(70)
        
        openView
            .width(70)
        
        deleteView
            .width(70)
        
        copyView.layout(
            0,
            |-(>=0)-copyButton.width(40).centerHorizontally()-(>=0)-| ~ 40,
            |copyButtonTitle|,
            0
        )
        
        openView.layout(
            0,
            |-(>=0)-openButton.width(40).centerHorizontally()-(>=0)-| ~ 40,
            |openButtonTitle|,
            0
        )
        
        deleteView.layout(
            0,
            |-(>=0)-deleteButton.width(40).centerHorizontally()-(>=0)-| ~ 40,
            |deleteButtonTitle|,
            0
        )
    }
}
