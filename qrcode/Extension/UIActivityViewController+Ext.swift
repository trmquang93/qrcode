//
//  UIActivityViewController+Ext.swift
//  qrcode
//
//  Created by Quang Tran on 2/9/21.
//

import UIKit
import MBProgressHUD

extension UIActivityViewController {
    
    static func shareCode(_ code: QRCode, from parent: UIViewController, sourceView: UIView?) {
        let hud = MBProgressHUD.showAdded(to: parent.view, animated: true)
        code.generateCode { image in
            let tempFile = QRFileManager.temporaryDirectory.appendingPathComponent("code.png")
            try? FileManager.default.removeItem(at: tempFile)
            
            try? image?.pngData()?.write(to: tempFile)
            DispatchQueue.main.async {
                share(items: [tempFile], from: parent, sourceView: sourceView)
                hud.hide(animated: true)
            }
        }
    }
    
    static func share(items: [Any], from parent: UIViewController, sourceView: UIView?) {
        let activityViewController = UIActivityViewController(activityItems: items, applicationActivities: nil)
        
        activityViewController.popoverPresentationController?.sourceView = sourceView ?? parent.view
        activityViewController.popoverPresentationController?.sourceRect = sourceView.map({parent.view.convert($0.frame, from: $0)}) ?? .zero
        
        parent.present(activityViewController, animated: true, completion: nil)
    }
}
