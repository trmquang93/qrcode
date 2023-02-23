//
//  QRCreateInputViewController.swift
//  qrcode
//
//  Created by Quang Tran on 2/10/21.
//

import UIKit
import AppStarter
import RealmSwift

class QRCreateInputViewController: QRViewController {
    weak var contentView: UIView!
    weak var createButton: DefaultButton!
    
    //sourcery:begin:ignore
    let type: QRCreateCodeType
    var data: [Int: Any] = [:]
    //sourcery:end
    
    init(type: QRCreateCodeType) {
        self.type = type
        
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createViews()
        setupViews()
        createConstraints()
        
    }
}

extension QRCreateInputViewController {
    var inputCode: String? {
        switch type {
        case .url:
            return data[0] as? String
        case .email:
            return "MATMSG:TO:\(stringFromData(key: .email_text));SUB:\(stringFromData(key: .Subject_text));BODY:\(stringFromData(key: .Body_text));;"
        case .phone:
            return "tel:\(stringFromData(key: .receiver_number_text))"
        case .vcard:
            return """
            BEGIN:VCARD
            VERSION:3.0
            N:\(stringFromData(key: .lastName_text));\(stringFromData(key: .firstName_text))
            FN:\(stringFromData(key: .firstName_text)) \(stringFromData(key: .lastName_text))
            ORG:\(stringFromData(key: .company_text))
            TITLE:\(stringFromData(key: .title_text))
            ADR:;;\(stringFromData(key: .street_text));\(stringFromData(key: .city_text));\(stringFromData(key: .province_text));\(stringFromData(key: .postCode_text));\(stringFromData(key: .country_text))
            TEL;WORK;VOICE:\(stringFromData(key: .phoneNumber_text))
            TEL;CELL:\(stringFromData(key: .mobileNumber_text))
            TEL;FAX:\(stringFromData(key: .fax_text))
            EMAIL;WORK;INTERNET:\(stringFromData(key: .email_text))
            URL:\(stringFromData(key: .website_text))
            BDAY:\(stringFromData(key: .birthDay_text))
            END:VCARD
            """
        case .text:
            return data[0] as? String
        case .sms:
            return "SMSTO:\(stringFromData(key: .receiver_number_text)):\(stringFromData(key: .sms_body_text))"
        case .wifi:
            return "WIFI:T:\(stringFromData(key: .wifi_encryption_text));S:\(stringFromData(key: .ssid_text));P:\(stringFromData(key: .wifi_password_text));H:\(stringFromData(key: .wifi_hidden_text))"
        }
    }
    
    func stringFromData(key: QRValueFieldName) -> String {
        guard let index = type.fieldNames.firstIndex(of: key) else { return ""}
        return data[index] as? String ?? ""
        
    }
}

extension QRCreateInputViewController {
    func setupContentView() {
        let viewController = QRInputsViewController(inputFields: type.fieldNames.map({QRInputField(label: $0, isTextView: $0.isTextView)}))
        
        viewController.data.subscribe(onNext: {[weak self] data in
            self?.data = data
        }).disposed(by: viewController.disposeBag)
        
        addChild(viewController, to: contentView)
    }
    
    @objc func showResult() {
        guard let inputCode = self.inputCode else { return }
        saveResult()
        let viewController = QRScanResultViewController(viewModel: VMCodeResult(code: QRCode(stringValue: inputCode, codeType: .qrCode)))
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func saveResult() {
        guard let inputCode = self.inputCode else { return }
        let realm = try! Realm()
        let object = RLMCreatedCode()
        object.code = inputCode
        try! realm.write {
            realm.add(object)
        }
    }
}

extension QRCreateInputViewController: ViewControllerAutoCreateViews {
    func setupViews() {
        setupContentView()
        
        createButton.style {
            $0.setTitle("create_button".localized, for: .normal)
            $0.addTarget(self, action: #selector(showResult), for: .touchUpInside)
        }
    }
    
    func createConstraints() {
        view.layout {
            |contentView|
            |-(>=0)-createButton-(>=0)-| ~ 50
        }
        
        contentView
            .top(topAnchor)
        
        createButton
            .bottom(bottomAnchor, constant: -20)
            .centerHorizontally()
            .width(250)
    }
}
