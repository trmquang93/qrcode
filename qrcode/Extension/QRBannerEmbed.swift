//
//  QRBannerEmbed.swift
//  qrcode
//
//  Created by Quang Tran on 2/6/21.
//

import UIKit
import RxCocoa
import RxRealm
import RxSwift
import AppStarter
import UnitAdsManager

protocol QRBannerEmbed: class {
    var bannerView: UIView! { get }
    func addBanner()
    func observeUserPurchases()
}

fileprivate struct SerializedKey {
    static var bannerHeight = "SerializedKey.bannerHeight"
    static var bannerView = "SerializedKey.bannerView"
}

extension QRBannerEmbed where Self: UIViewController {
    var bannerView: UIView! {
        if let view = objc_getAssociatedObject(self, &SerializedKey.bannerView) as? UIView {
            return view
        } else {
            let view = UIView()
            view.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview(view)
            view.heightAnchor.constraint(greaterThanOrEqualToConstant: 0).isActive = true
            let height = view.heightAnchor.constraint(equalToConstant: AdsHepler.Constant.bannerSize.size.height)
            height.isActive = true
            objc_setAssociatedObject(self, &SerializedKey.bannerView, view, .OBJC_ASSOCIATION_ASSIGN)
            return view
        }
    }
    
    func addBanner() {
        if bannerView.isHidden { return }
        let banner = AdsHepler.shared.currentBanner
        
        if banner.adSize.size.width != AdsHepler.Constant.bannerSize.size.width {
            AdsHepler.shared.createBanners()
        }
        
        if banner.superview == nil {
            banner.translatesAutoresizingMaskIntoConstraints = false
        } else {
            banner.removeFromSuperview()
        }
        
        banner.setContentCompressionResistancePriority(.required, for: .vertical)
        banner.setContentCompressionResistancePriority(.required, for: .horizontal)
        
        bannerView.addSubview(banner)
        
        NSLayoutConstraint.activate(banner.constraints(equalTo: bannerView, attributes: [.height, .centerX]))
        
    }
}

extension QRBannerEmbed where Self: UIViewController {
    
    func observeUserPurchases() {
        let user = RLMUser.current
        Observable.from(object: user).subscribe(onNext: {[weak self] user in
            guard let sSelf = self else { return }
            sSelf.bannerView.isHidden = user.isPuchased
        }).disposed(by: disposeBag)
    }
}
