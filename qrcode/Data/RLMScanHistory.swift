//
//  RLMScanHistory.swift
//  qrcode
//
//  Created by Quang Tran on 2/8/21.
//

import Foundation
import RealmSwift

class RLMScanHistory: Object {
    @objc dynamic var date = Date()
    @objc dynamic var code: String = ""
    @objc dynamic var isNew = true
    @objc dynamic var codeType: Int = 0
}
