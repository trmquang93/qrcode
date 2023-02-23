//
//  RLMCreatedCode.swift
//  qrcode
//
//  Created by Quang Tran on 2/19/21.
//

import Foundation
import RealmSwift

class RLMCreatedCode: Object {
    @objc dynamic var date = Date()
    @objc dynamic var code: String = ""
    @objc dynamic var isNew = true
}
