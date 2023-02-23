//
//  QRTabbarViewController.swift
//  qrcode
//
//  Created by Quang Tran on 2/6/21.
//

import UIKit
import AppStarter
import RxSwift
import RealmSwift
import UnitAdsManager

class QRTabbarViewController: UIViewController, ViewControllerAutoCreateViews {
    weak var stackContentView: UIStackView!
    
    //sourcery:begin: superView = stackContentView, stackView
    weak var contentView: UIView!
    weak var tabbar: UITabBar!
    //sourcery:end
    
    override func loadView() {
        let view = UIView()
        view.backgroundColor = .backgroundColor
        
        self.view = view
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createViews()
        setupViews()
        createConstraints()
        
        setupViewControllers()
        observeNewItems()
        
        AdsHepler.shared.createAndLoadInterstitial()
    }
    
    func setupViewControllers() {
        var viewControllers: [UIViewController] = []
        var tabbarItems: [UITabBarItem] = []
        
        for item in QRTabbarItem.allCases {
            var itemViewController: UIViewController!
            switch item {
            case .scan:
                itemViewController = QRScanViewController()
            case .history:
                itemViewController = QRHistoryViewController()
            case .create:
                itemViewController = QRMyCodeViewController()
            case .settings:
                itemViewController = QRSettingsViewController()
            }
            
            let barItem = item.barItem
            itemViewController.navigationItem.title = item.title
            let viewController = UINavigationController(rootViewController: itemViewController)
            viewController.tabBarItem = barItem
            
            viewControllers.append(viewController)
            tabbarItems.append(barItem)
        }
        
        setViewControllers(viewControllers, to: contentView)
        tabbar.setItems(tabbarItems, animated: false)
        tabbar.selectedItem = tabbarItems.first
    }
    
    func setupViews() {
        stackContentView.style {
            $0.axis = .vertical
            $0.alignment = .fill
        }
        
        tabbar.delegate = self
    }
    
    func createConstraints() {
        stackContentView
            .fillContainer()
        
        tabbar
            .bottom(bottomAnchor)
            .height(50)
    }
    
    func setTabbarHidden(_ isHidden: Bool) {
        tabbar.isHidden = isHidden
    }
}

extension QRTabbarViewController: UITabBarDelegate {
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if let currentViewController = children(in: contentView).first, currentViewController.tabBarItem == item {
            guard let navigationController = children[item.tag] as? UINavigationController else { return }
            navigationController.popToRootViewController(animated: true)
            
        } else {
            switchToViewController(at: item.tag, in: contentView)
        }
    }
}

extension QRTabbarViewController {
    func observeNewItems() {
        let items = (try! Realm()).objects(RLMScanHistory.self)
        Observable.collection(from: items.filter("isNew == true")).map({$0.count})
            .subscribe(onNext: {[weak self] count in
                guard let `self` = self, let viewController = self.children.first(where: {($0 as? UINavigationController)?.viewControllers.first is QRHistoryViewController}) else { return }
                viewController.tabBarItem.badgeValue = count == 0 ? nil : "\(count)"
            }).disposed(by: disposeBag)
        
        let myitems = (try! Realm()).objects(RLMCreatedCode.self)
        Observable.collection(from: myitems.filter("isNew == true")).map({$0.count})
            .subscribe(onNext: {[weak self] count in
                guard let `self` = self, let viewController = self.children.first(where: {($0 as? UINavigationController)?.viewControllers.first is QRMyCodeViewController}) else { return }
                viewController.tabBarItem.badgeValue = count == 0 ? nil : "\(count)"
            }).disposed(by: disposeBag)
    }
}

extension UIViewController {
    var qrTabBarController: QRTabbarViewController? {
        var parent: UIViewController? = self.parent
        while let vc = parent {
            if let parentViewController = vc as? QRTabbarViewController {
                return parentViewController
            } else {
                parent = vc.parent
            }
        }
        return nil
    }
}

enum QRTabbarItem: Int, CaseIterable {
    case scan
    case history
    case create
    case settings
    
    var barItem: UITabBarItem {
        return UITabBarItem(title: title, image: UIImage(named: iconName), tag: rawValue)
    }
    
    var title: String {
        return "\(self)_tabbar_name".localized
    }
    
    var iconName: String {
        return "\(self)_tabbar_ic"
    }
    
}
