//
//  QRSettingsViewController.swift
//  qrcode
//
//  Created by Quang Tran on 2/9/21.
//

import UIKit
import AppStarter
import MessageUI
import MBProgressHUD
import RxSwift

class QRSettingsViewController: QRViewController, ASTableViewControllerWithViewModel, QRBannerEmbed {
    
    //sourcery:begin: ignore
    var viewModel: VMSettings
    //sourcery:end
    
    init(viewModel: VMSettings = VMSettings()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        tableViewDataSource = ASTableViewDataSource(viewModel: viewModel, viewController: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.alwaysBounceVertical = false
    }
    
    
    func setupCell(_ tableView: UITableView, cell: UITableViewCell, at indexPath: IndexPath) {
        guard let cell = cell as? QRSettingCell, let cellVM = viewModel.cellViewModelForItem(at: indexPath) else {return}
        cell.setUp(cellVM)
    }
}

extension QRSettingsViewController {
    func createConstraints() {
        view.layout(
            |bannerView|,
            |tableView|,
            0
        )
        
        bannerView
            .top(topAnchor)
    }
}

extension QRSettingsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let item = viewModel.itemForCell(at: indexPath) else {return}
        switch item {
            
        case .rate:
            reviewApp()
        case .feedback:
            sendFeedbackEmail()
        }
    }
    
    func reviewApp() {
        let url = URL(string:"https://itunes.apple.com/app/id1552346918?action=write-review")!
        UIApplication.shared.open(url)
    }
    
    
    func sendFeedbackEmail() {
        if !MFMailComposeViewController.canSendMail() {
            
            let alert = UIAlertController(title: "VTLSettingViewController_no_mail_title".localized, message: "VTLSettingViewController_no_mail_message".localized, preferredStyle: .alert)
            let ok = UIAlertAction(title: "ok_button".localized, style: .default) { ok in
                alert.dismiss(animated: true, completion: nil)
            }
            alert.addAction(ok)
            
            present(alert, animated: true, completion: nil)
            
            return
        }
        
        let mail = MFMailComposeViewController()
        mail.mailComposeDelegate = self
        let version = (Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String) ?? ""
        let appName = (Bundle.main.infoDictionary?["CFBundleName"] as? String) ?? ""
        let mailSubject = String(format: "Message_Subject".localized, appName, version)
        
        mail.setSubject(mailSubject)
        mail.setToRecipients(["inest.help@gmail.com"])
        mail.setMessageBody("Message_Body".localized, isHTML: false)
        
        navigationController?.present(mail, animated: true, completion: nil)
    }
}

extension QRSettingsViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}

