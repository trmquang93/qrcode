//
//  QRDecoder.swift
//  qrcode
//
//  Created by Quang Tran on 2/7/21.
//

import UIKit
import UniformTypeIdentifiers
import ZXingObjC
import MLKitBarcodeScanning

class QRDecoder {
    static func decode(_ codeString: String) -> QRValueType {
        
        if codeString.matched(regexString: "^SMSTO:.*:.*") {
            return .sms
        }
        
        if codeString.matched(regexString: "^WIFI:T:.*;S:.*;P:.*;[H:]*.*") {
            return .wifi
            
        }
        
        if VCARD.decoded(from: codeString) != nil {
            return .vcard
        }
        
        if codeString.matched(regexString: "^tel:.*") {
            return .phone
        }
        
        if codeString.matched(regexString: "^MATMSG:TO:.*;SUB:.*;BODY:.*;;") || codeString.matched(regexString: "^MAILTO:.*") {
            return .email
        }
        
        
        if let url = URL(string: codeString), UIApplication.shared.canOpenURL(url) {
            return .url
        }
        
        if codeString.matched(regexString: "^[0-9+]+$") {
            return .number
        }
        
        return .text
    }
}

struct QRCode {
    let stringValue: String
    var codeType: BarcodeFormat
    var valueType: QRValueType {
        return QRDecoder.decode(stringValue)
    }
    
    
    func generateCode(completion: @escaping ((UIImage?) -> Void)) {
        DispatchQueue.global(qos: .userInitiated).async {
            let codeWriter = ZXMultiFormatWriter()
            var writerFormat: ZXBarcodeFormat
            switch codeType {
            case .qrCode:
                writerFormat = kBarcodeFormatQRCode
            case .code128:
                writerFormat = kBarcodeFormatCode128
            case .code39:
                writerFormat = kBarcodeFormatCode39
            case .code93:
                writerFormat = kBarcodeFormatCode93
            case .codaBar:
                writerFormat = kBarcodeFormatCodabar
            case .dataMatrix:
                writerFormat = kBarcodeFormatDataMatrix
            case .EAN13:
                writerFormat = kBarcodeFormatEan13
            case .EAN8:
                writerFormat = kBarcodeFormatEan8
            case .ITF:
                writerFormat = kBarcodeFormatITF
            case .UPCA:
                writerFormat = kBarcodeFormatUPCA
            case .UPCE:
                writerFormat = kBarcodeFormatUPCE
            case .PDF417:
                writerFormat = kBarcodeFormatPDF417
            case .aztec:
                writerFormat = kBarcodeFormatAztec
            default:
                writerFormat = kBarcodeFormatQRCode
            }
            
            autoreleasepool {
                do {
                    let result = try codeWriter.encode(stringValue, format: writerFormat, width: Int32(codeType.codeSize.width), height: Int32(codeType.codeSize.height))
                    let cgimage = ZXImage(matrix: result)?.cgimage
                    let uiimage = cgimage.map({UIImage(cgImage: $0)})
                    completion(uiimage)
                } catch {
                    completion(nil)
                }
            }
        }
    }
}

extension BarcodeFormat {
    var codeSize: CGSize {
        switch self {
        case .qrCode, .dataMatrix:
            return CGSize(width: 500, height: 500)
        default:
            return CGSize(width: 1200, height: 500)
        }
    }
}

enum QRValueType: Int {
    case url
    case email
    case phone
    case text
    case vcard
    case wifi
    case sms
    case number
    
    var name: String {
        return "create_\(self)".localized
    }
    
    var iconName: String {
        return "create_\(self)_ic"
    }
    
    func decode(string: String) -> [QRInputField] {
        var fields: [QRInputField] = []
        switch self {
        case .url:
            fields.append(QRInputField(label: .URL_text, isTextView: false, value: string))
        case .email:
            var emailAddress = ""
            var body = ""
            var subject = ""
            
            if string.matched(regexString: "MATMSG:TO:.*;SUB:.*;BODY:.*;;") {
                if let matched = string.firstMatch(for: "MATMSG:TO:.*;SUB")?
                    .replacingOccurrences(of: "MATMSG:TO:", with: "")
                    .replacingOccurrences(of: ";SUB", with: "") {
                    emailAddress = matched
                }
                
                if let matched = string.firstMatch(for: "SUB:.*;BODY")?
                    .replacingOccurrences(of: "SUB:", with: "")
                    .replacingOccurrences(of: ";BODY", with: "") {
                    subject = matched
                }
                
                if let matched = string.firstMatch(for: "BODY:.*;;")?
                    .replacingOccurrences(of: "BODY:", with: "")
                    .replacingOccurrences(of: ";;", with: "") {
                    body = matched
                }
            } else if string.matched(regexString: "^mailto:.*") || string.matched(regexString: "^MAILTO:.*") {
                let components = string.components(separatedBy: ":")
                
                if components.indices.contains(1) {
                    emailAddress = components[1]
                }
                
                if components.indices.contains(2) {
                    subject = components[2]
                }
                
                if components.indices.contains(3) {
                    body = components[3]
                }
            }
            fields.append(QRInputField(label: .email_text, isTextView: false, value: emailAddress))
            fields.append(QRInputField(label: .Subject_text, isTextView: false, value: subject))
            fields.append(QRInputField(label: .Body_text, isTextView: true, value: body))
            
        case .phone:
            if string.matched(regexString: "tel:.*") || string.matched(regexString: "^[0-9+]{0,1}+[0-9]{5,16}$") {
                let phoneNumber = string.replacingOccurrences(of: "tel:", with: "")
                fields.append(QRInputField(label: .phoneNumber_text, isTextView: false, value: phoneNumber))
            }
        case .text:
            fields.append(QRInputField(label: .sms_body_text, isTextView: true, value: string))
        case .vcard:
            guard let vcard = VCARD.decoded(from: string) else { break }
            fields.append(contentsOf: vcard.fields)
        case .wifi:
            let wifi = QRWifi(code: string)
            
            fields.append(QRInputField(label: .ssid_text, isTextView: false, value: wifi.ssid ?? ""))
            fields.append(QRInputField(label: .wifi_encryption_text, isTextView: false, value: wifi.encryption ?? ""))
            fields.append(QRInputField(label: .wifi_password_text, isTextView: false, value: wifi.password ?? ""))
            fields.append(QRInputField(label: .wifi_hidden_text, isTextView: false, value: "\(wifi.hidden)"))
            
        case .sms:
            if string.matched(regexString: "SMSTO:.*:.*") {
                let components = string.components(separatedBy: ":")
                var number = ""
                var message = ""
                if components.indices.contains(1) {
                    number = components[1]
                }
                
                if components.indices.contains(2) {
                    message = components[2]
                }
                fields.append(QRInputField(label: .receiver_number_text, isTextView: false, value: number))
                fields.append(QRInputField(label: .sms_body_text, isTextView: true, value: message))
            }
            
        case .number:
            fields.append(QRInputField(label: .number_text, isTextView: false, value: string))
        }
        return fields
    }
}

enum QRValueFieldName: String {
    case URL_text
    case Subject_text
    case Body_text
    case receiver_number_text
    case firstName_text
    case lastName_text
    case street_text
    case city_text
    case postCode_text
    case country_text
    case province_text
    case mobileNumber_text
    case phoneNumber_text
    case fax_text
    case email_text
    case website_text
    case birthDay_text
    case company_text
    case title_text
    case sms_body_text
    case ssid_text
    case wifi_encryption_text
    case wifi_password_text
    case wifi_hidden_text
    case number_text
    
    var isTextView: Bool {
        switch self {
        case .Body_text,
             .sms_body_text:
            return true
        default:
            return false
        }
    }
}
