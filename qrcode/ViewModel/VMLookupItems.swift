//
//  VMLookupItems.swift
//  qrcode
//
//  Created by Quang Tran on 2/19/21.
//

import Foundation
import AppStarter

class VMLookupItems: ASViewModelListData {
    var itemIdentifiers: [String : AnyClass] {
        [
            QRLookupItemCell.className : QRLookupItemCell.self
        ]
    }
    
    var items: [Item]! = Item.allCases
}

extension VMLookupItems {
    enum Item: Int, CaseIterable {
        case google
        case yahoo
        case bing
        case amazon
        case googleShopping
        case ebay
        case walmart
        case target
        case bestbuy
        case duckduckgo
        
        var iconName: String {
            return "lookup_\(self)_ic"
        }
    }
}
