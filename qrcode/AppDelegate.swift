//
//  AppDelegate.swift
//  qrcode
//
//  Created by Quang Tran on 2/6/21.
//

import UIKit
import Firebase
import IQKeyboardManagerSwift
import UnitAdsManager
import RealmSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        AdsHepler.setTestIdentifiers(["edb48772d8916129de1c36c55586647c"])
        setupKeyboard()
        Realm.config()
        loadRootViewController()
        
        return true
    }
    
    
}

extension AppDelegate {
    func setupKeyboard() {
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.toolbarTintColor = .tintColor
    }
}

extension AppDelegate {
    func loadRootViewController() {
        UIView.setupAppearance()
        let viewController = QRTabbarViewController()
        let window = self.window ?? UIWindow()
        
        window.makeKeyAndVisible()
        
        window.rootViewController = viewController
        
        self.window = window
    }
}

