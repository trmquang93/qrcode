//
//  QRScanView.swift
//  qrcode
//
//  Created by Quang Tran on 2/17/21.
//

import UIKit
import AppStarter
import Lottie

class QRScanView: UIView {
    weak var scanSquareView: UIImageView!
    
    //sourcery:begin: superView = scanSquareView
    weak var scanIndicator: LottieAnimationView!
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
    
//    override func draw(_ rect: CGRect) {
//        super.draw(rect)
//        scanIndicator.forceDisplayUpdate()
//    }
}


extension QRScanView: AutoCreateViews {
    func setupViews() {
        scanSquareView.style {
            $0.image = UIImage(named: "scan_square_ic")
            $0.contentMode = .scaleAspectFill
        }

        
        scanIndicator.style {
            $0.animation = .named("scan-matrix")
            $0.contentMode = .scaleAspectFill
            $0.loopMode = .loop
        }
    }
    
    func createConstraints() {
        scanSquareView
            .centerHorizontally()
            .centerVertically()
            .width(50%)
            .heightEqualsWidth()
   
        scanIndicator
            .centerVertically()
            .centerHorizontally()
            .width(93%)
            .height(94%)
    }
}
