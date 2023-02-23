//
//  QRCodeListProtocol.swift
//  qrcode
//
//  Created by Quang Tran on 2/19/21.
//

import UIKit


protocol QRCodeListProtocol where Self: UIViewController {
    func disableSelection()
    func valueAt(indexPath: IndexPath) -> QRCode?
    func deleteAt(indexPath: IndexPath)
}


extension QRCodeListProtocol {
    func copyItem(at indexPath: IndexPath) {
        guard let code = valueAt(indexPath: indexPath) else { return }
        UIPasteboard.general.string = code.stringValue
        disableSelection()
        showAlert(withTitle: "copied_to_clipboard_title".localized, message: "copied_to_clipboard".localized)
    }
    
    func shareItem(at indexPath: IndexPath, from: UIView?) {
        guard let item = valueAt(indexPath: indexPath) else {
            return
        }
        UIActivityViewController.shareCode(item, from: self, sourceView: from)
    }
    
    func askDeleteItem(at indexPath: IndexPath) {
        showWarnig(withTitle: "Delete_sure".localized, message: "Delete_msg".localized) {[unowned self] in
            self.deleteAt(indexPath: indexPath)
        }
    }
}
