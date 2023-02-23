//
//  VMCreate.swift
//  qrcode
//
//  Created by Quang Tran on 2/9/21.
//

import Foundation
import AppStarter


class VMCreate: ASViewModelListData {
    var itemIdentifiers: [String : AnyClass] {
        [
            QRCreateCodeCell.className: QRCreateCodeCell.self
        ]
    }
    
    var items: [QRCreateCodeType]! = QRCreateCodeType.allCases
}

enum QRCreateCodeType: Int, CaseIterable {
    case url
    case email
    case phone
    case vcard
    case text
    case sms
    case wifi
    
    var name: String {
        return "create_\(self)".localized
    }
    
    var iconName: String {
        return "create_\(self)_ic"
    }
    
    var color: UIColor {
        switch self {
        case .url:
            return UIColor(red: 0.996, green: 0.961, blue: 0.933, alpha: 1)
        case .email:
            return UIColor(red: 0.992, green: 0.929, blue: 0.929, alpha: 1)
        case .phone:
            return UIColor(red: 0.929, green: 0.973, blue: 0.941, alpha: 1)
        case .text:
            return UIColor(red: 0.933, green: 0.969, blue: 0.996, alpha: 1)
        case .vcard:
            return UIColor(red: 0.98, green: 0.914, blue: 0.937, alpha: 1)
        case .wifi:
            return UIColor(red: 0.894, green: 0.98, blue: 0.933, alpha: 1)
        case .sms:
            return UIColor(red: 0.945, green: 0.969, blue: 0.922, alpha: 1)
        }
    }
    
    var fieldNames: [QRValueFieldName] {
        switch self {
        case .url:
            return [
                .URL_text
            ]
        case .email:
            return [
                .email_text,
                .Subject_text,
                .Body_text,
            ]
        case .phone:
            return [
                .receiver_number_text
            ]
        case .vcard:
            return [
                .firstName_text,
                .lastName_text,
                .street_text,
                .city_text,
                .postCode_text,
                .country_text,
                .province_text,
                .mobileNumber_text,
                .phoneNumber_text,
                .fax_text,
                .email_text,
                .website_text,
                .birthDay_text,
                .company_text,
                .title_text,
            ]
        case .text:
            return [
                .sms_body_text,
            ]
        case .sms:
            return [
                .receiver_number_text,
                .sms_body_text,
            ]
        case .wifi:
            return [
                .ssid_text,
                .wifi_encryption_text,
                .wifi_password_text,
                .wifi_hidden_text,
            ]
        }
    }
}
