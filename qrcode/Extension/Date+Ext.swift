//
//  Date+Ext.swift
//  qrcode
//
//  Created by Quang Tran on 2/8/21.
//

import Foundation

extension Date {
    func toString(format: String = "dd/mm/yyy") -> String {
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = format
        return dateFormater.string(from: self)
    }
}
