//
//  VMEmailResult.swift
//  qrcode
//
//  Created by Quang Tran on 2/8/21.
//

import Foundation


class VMEmail {
    
    var email: String?
    var subject: String?
    var body: String?
    
    init(email: String? = nil, subject: String? = nil, body: String? = nil) {
        self.email = email
        self.subject = subject
        self.body = body
    }
    
    
    var fields: [QRInputField] {
        [
            .init(label: .email_text, value: email),
            .init(label: .Subject_text, value: subject),
            .init(label: .Body_text, isTextView: true, value: body)
        ]
    }
    
    var emailURL: String {
        let email = self.email ?? ""
        let subject = self.subject ?? ""
        let body = self.body ?? ""
        let string = "mailto:\(email)?subject=\(subject)&body=\(body)"
        return string.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? string
    }
}

struct QRInputField {
    var label: QRValueFieldName
    var placeHolder: String { return label.rawValue.localized }
    var isTextView: Bool = false
    var value: String?
}
