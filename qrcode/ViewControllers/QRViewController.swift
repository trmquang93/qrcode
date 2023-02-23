//
//  QRViewController.swift
//  qrcode
//
//  Created by Quang Tran on 2/6/21.
//

import UIKit
import AppStarter

class QRViewController: UNViewController {
    var preferNavigationBarHidden: Bool { return false }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let bannerEmbed = self as? (UIViewController & QRBannerEmbed) {
            bannerEmbed.observeUserPurchases()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(preferNavigationBarHidden, animated: animated)
        
        if let bannerEmbed = self as? (UIViewController & QRBannerEmbed) {
            bannerEmbed.addBanner()
        }
    }
    
    override func setupView() {
        view.backgroundColor = .backgroundColor
    }
}
