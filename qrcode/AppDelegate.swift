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
import AppTrackingTransparency
import AdSupport

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var wasInBackground = false
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        
        setupKeyboard()
        Realm.config()
        loadRootViewController()
        configAds()
        return true
    }
    
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        if wasInBackground {
            showOpenAdsIfNeeded()
        }
        wasInBackground = false
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        wasInBackground = true
    }

    func showOpenAdsIfNeeded() {
        AdsHepler.shared.setAppOpenAdNeedPresented()
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

@available(iOS 14, *)
extension AppDelegate {
    func requestIDFA() {
        ATTrackingManager.requestTrackingAuthorization(completionHandler: { [weak self] status in
            // Tracking authorization completed. Start loading ads here.
            // loadAd()
            debugPrint("TrackingAuthorizationStatus: \(status)")
            self?.loadAds()
        })
    }
}

extension AppDelegate {
    func loadAds() {
        //Load Interstitial and AppOpen ads
        AdsHepler.shared.createAndLoadInterstitial()
        AdsHepler.shared.requestAppOpenAd()
    }
    
    func configAds() {
        AdsHepler.setTestIdentifiers(["47fbd6587d573a2213cd3e273331b1f0"])
        
        //Set ids for ads before loading them
        AdsHepler.shared.adsIDs[.banner] = "ca-app-pub-4165907565058660/2099473555"
        AdsHepler.shared.adsIDs[.interstitial] = "ca-app-pub-4165907565058660/7160228540"
        AdsHepler.shared.adsIDs[.appOpenAd] = "ca-app-pub-4165907565058660/3977508491"

        if #available(iOS 14, *) {
            requestIDFA()
        } else {
            loadAds()
        }
    }
}
