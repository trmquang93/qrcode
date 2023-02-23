//
//  VMSMS.swift
//  qrcode
//
//  Created by Quang Tran on 2/8/21.
//

import Foundation

class VMSMS {
    var number: String = ""
    var body: String = ""
    
    var fields: [QRInputField] {
        [
            QRInputField(label: .receiver_number_text, value: number),
            QRInputField(label: .sms_body_text, isTextView: true, value: body),
        ]
    }
    
    var code: String {
        return "SMSTO:\(number):\(body)"
    }
}
