//
//  QRWifi.swift
//  qrcode
//
//  Created by Quang Tran on 2/8/21.
//

import Foundation
import NetworkExtension

struct QRWifi {
    let dictCode: [String:Any]
    var ssid: String? {
        return dictCode["S"] as? String
    }
    
    var encryption: String? {
        return dictCode["T"] as? String
    }
    
    var password: String? {
        return dictCode["P"] as? String
    }
    
    var hidden: Bool {
        return dictCode["H"] as? Bool ?? false
    }
    
    init(code: String) {
        var dictCode: [String: Any] = [:]
        var datacode = code
            .replacingOccurrences(of: "WIFI:", with: "")
        datacode = String(datacode.dropLast())
        
        let components = datacode.components(separatedBy: ";")
        for pare in components {
            let pareComponents = pare.components(separatedBy: ":")
            guard pareComponents.count >= 2 else { continue }
            dictCode[pareComponents[0]] = pareComponents[1]
        }
        
        self.dictCode = dictCode
    }
    
    var hotspotConfiguration: NEHotspotConfiguration? {
        guard let wifi_ssid = dictCode["S"] as? String else { return nil }
        let wifi_pwd = dictCode["P"] as? String ?? ""
        let wifi_type = dictCode["T"] as? String
        
        let configuration = NEHotspotConfiguration.init(ssid: wifi_ssid, passphrase: wifi_pwd, isWEP: wifi_type == "WEP")
        configuration.joinOnce = true
        
        return configuration
    }
    
    var fields: [QRInputField] {
        [
            .init(label: .ssid_text, value: ssid),
            .init(label: .wifi_encryption_text, value: encryption),
            .init(label: .wifi_password_text, value: password),
            .init(label: .wifi_hidden_text, value: "\(hidden)"),
        ]
    }
}
