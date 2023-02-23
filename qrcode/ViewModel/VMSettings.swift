//
//  VMCreate.swift
//  qrcode
//
//  Created by Quang Tran on 2/9/21.
//

import Foundation
import AppStarter

class VMSettings: ASViewModelData {
    
    var itemIdentifiers: [String : AnyClass] {
        return [QRSettingCell.className:QRSettingCell.self]
    }
    
    func numberOfItemInSection(_ section: Int) -> Int {
        return SettingOptions.allCases.count
    }
    
    func itemForCell(at indexPath: IndexPath) -> SettingOptions? {
        guard SettingOptions.allCases.count > indexPath.row else {return nil}
        let item = SettingOptions.allCases[indexPath.row]
        return item
    }
    
    func cellViewModelForItem(at indexPath: IndexPath) -> VMSettingTableCell? {
        guard let item = itemForCell(at: indexPath) else {return nil}
        return VMSettingTableCell(iconName: item.iconName, title: item.title, content: item.subTitle)
    }
}

enum SettingOptions: Int, CaseIterable {
    case rate, feedback
    
    var title: String {
        return "SettingOptions_title_\(self)".localized
    }
    
    var subTitle: String? {
        return "SettingOptions_subTitle_\(self)".localized
    }
    
    var iconName: String {
        return "SettingOptions_icon_\(self)"
    }
}
