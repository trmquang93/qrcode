//
//  QRResultViewController.swift
//  qrcode
//
//  Created by Quang Tran on 2/19/21.
//

import UIKit
import AppStarter
import NetworkExtension
import ContactsUI

class QRResultViewController: QRViewController {
    weak var codeDetailView: UIView!
    weak var actionButton: DefaultButton!
    weak var shareButton: DefaultButton!
    
    //sourcery:begin: ignore
    var viewModel: VMCodeResult
    //sourcery:end
    
    init(viewModel: VMCodeResult) {
        self.viewModel = viewModel
        
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
    
    func createConstraints() {
        view.layout {
            0
            |codeDetailView|
            |-(>=0)-actionButton-(>=0)-|
        }
        
        actionButton
            .bottom(bottomAnchor, constant: -20)
            .height(50)
            .width(150)
            .trailing(view.centerXAnchor, constant: -15)
        
        shareButton
            .bottom(bottomAnchor, constant: -20)
            .height(50)
            .width(150)
            .leading(view.centerXAnchor, constant: 15)
        
    }
}

extension QRResultViewController {
    
    func setupResultView() {
        let fields = viewModel.code.valueType.decode(string: viewModel.code.stringValue)
        let viewController = QRInputsViewController(inputFields: fields, isEnabled: false)
        
        addChild(viewController, to: codeDetailView)
    }
    
    func setupActionButton() {
        var buttonTitle = "open_button".localized
        switch viewModel.code.valueType {
        case .url:
            buttonTitle = "open_button".localized
        case .email:
            buttonTitle = "send_email_button".localized
        case .phone:
            buttonTitle = "call_button".localized
        case .text:
            buttonTitle = "copy_button".localized
        case .vcard:
            buttonTitle = "add_contact_button".localized
        case .wifi:
            buttonTitle = "connect_button".localized
        case .sms:
            buttonTitle = "send_sms_button".localized
        case .number:
            buttonTitle = "copy_button".localized
        }
        
        actionButton.setTitle(buttonTitle, for: .normal)
        actionButton.addTarget(self, action: #selector(openContent), for: .touchUpInside)
    }
}

extension QRResultViewController {
    @objc func openContent() {
        let fields = viewModel.code.valueType.decode(string: viewModel.code.stringValue)
        
        switch viewModel.code.valueType {
        case .url:
            guard let url = URL(string: viewModel.code.stringValue) else { return }
            UIApplication.shared.open(url)
            
        case .email:
            let email = fields.first(where: {$0.label == .email_text})?.value ?? ""
            let subject = fields.first(where: {$0.label == .Subject_text})?.value ?? ""
            let body = fields.first(where: {$0.label == .Body_text})?.value ?? ""
            guard let string = "mailto:\(email)?subject=\(subject)&body=\(body)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
                  let url = URL(string: string)
            else { return }
            UIApplication.shared.open(url)
            
        case .phone:
            guard let url = URL(string: viewModel.code.stringValue) else { return }
            UIApplication.shared.open(url)
            
        case .text:
            copyCode()
        case .vcard:
            guard let card = VCARD.decoded(from: viewModel.code.stringValue) else { return }
            createContact(card: card)
            
        case .wifi:
            let wifi = QRWifi(code: viewModel.code.stringValue)
            connectWifi(wifi: wifi)
            
        case .sms:
            let receiver = fields.first(where: {$0.label == .receiver_number_text})?.value ?? ""
            let message = fields.first(where: {$0.label == .sms_body_text})?.value ?? ""
            guard let string = "sms:\(receiver)&body=\(message)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
                  let url = URL(string: string)
            else { return }
            UIApplication.shared.open(url)
            
        case .number:
            copyCode()
        }
    }
    
    @objc func shareCode() {
        UIActivityViewController.shareCode(viewModel.code, from: self, sourceView: shareButton)
    }
    
    func copyCode() {
        UIPasteboard.general.string = viewModel.code.stringValue
        showAlert(withTitle: "copied_to_clipboard_title".localized, message: "copied_to_clipboard".localized)
    }
    
    func handleConnectError(_ error: Error) {
        if error.localizedDescription == "already associated." {
            showAlert(withTitle: "connect_failed_text".localized, message: "connect_failed_already_associated".localized)
        } else {
            
            showAlert(withTitle: "connect_failed_text".localized, message: "connect_failed_msg".localized)
        }
    }
    
    func connectWifi(wifi: QRWifi) {
        guard let hotspotConfiguration = wifi.hotspotConfiguration else { return }
        
        NEHotspotConfigurationManager.shared.apply(hotspotConfiguration) {[weak self] error in
            if let err = error {
                DispatchQueue.main.async {[weak self] in
                    self?.handleConnectError(err)
                }
            } else {
                DispatchQueue.main.async {[weak self] in
                    self?.showAlert(withTitle: "connected_text".localized, message: String(format: "connected_msg_text".localized, wifi.ssid ?? ""))
                }
            }
        }
        
    }
    
    func createContact(card: VCARD) {
        guard let contact = try? CNContactVCardSerialization.contacts(with: Data(card.encoded.utf8)).first
        else {
            return
        }
        
        let viewController = CNContactViewController(forNewContact: contact)
        viewController.delegate = self
        present(UINavigationController(rootViewController: viewController), animated: true, completion: nil)
    }
}

extension QRResultViewController: CNContactViewControllerDelegate {
    func contactViewController(_ viewController: CNContactViewController, didCompleteWith contact: CNContact?) {
        viewController.dismiss(animated: true, completion: nil)
        showAlert(withTitle: "contact_saved".localized, message: "contact_saved_msg".localized)
    }
}


extension QRResultViewController: ViewControllerAutoCreateViews {
    
    func setupViews() {
        setupResultView()
        setupActionButton()
        
        shareButton.style {
            $0.setTitle("share_button".localized, for: .normal)
        }
        
        actionButton.addTarget(self, action: #selector(openContent), for: .touchUpInside)
        shareButton.addTarget(self, action: #selector(shareCode), for: .touchUpInside)
        
    }
}
