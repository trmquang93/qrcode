//
//  QRCodeLookupResultViewController.swift
//  qrcode
//
//  Created by Quang Tran on 2/19/21.
//

import UIKit
import AppStarter
import SafariServices


class QRCodeLookupResultViewController: QRResultViewController {
    weak var lookupHeaderLabel: UILabel!
    weak var lookupView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLookupView()
        
    }
    
    func setupLookupView() {
        let viewController = QRLookupItemsViewController()
        addChild(viewController, to: lookupView)
        
        viewController.didSelected.subscribe(onNext: {[weak self] item in
            self?.showSearchResult(for: item)
        }).disposed(by: viewController.disposeBag)
        
        lookupHeaderLabel.style {
            $0.font = UIFont.italic
            $0.textColor = .tintColor
            $0.text = "search_by".localized
        }
    }
    
    override func createConstraints() {
        view.layout(
            0,
            |codeDetailView| ~ 60,
            20,
            |-(>=0)-actionButton-(>=0)-|,
            10,
            |-20-lookupHeaderLabel-20-|,
            10,
            |lookupView|,
            0
        )
        
        actionButton
            .height(50)
            .width(150)
            .trailing(view.centerXAnchor, constant: -15)
        
        shareButton
            .height(50)
            .width(150)
            .leading(view.centerXAnchor, constant: 15)
        
        align(horizontally: [actionButton, shareButton])
    }
}

extension QRCodeLookupResultViewController {
    func showSearchResult(for item: VMLookupItems.Item) {
        var urlString: String = ""
        let query = viewModel.code.stringValue.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        switch item {
        case .google:
            urlString = "https://www.google.com/search?q=\(query)"
        case .yahoo:
            urlString = "https://www.search.yahoo.com/search?q=\(query)"
        case .bing:
            urlString = "https://www.bing.com/search?q=\(query)"
        case .amazon:
            urlString = "https://www.amazon.com/s?k=\(query)"
        case .googleShopping:
            urlString = "https://www.google.com/search?q=\(query)&tbm=shop&sclient=products-cc"
        case .ebay:
            urlString = "https://www.ebay.com/sch?_nkw=\(query)"
        case .walmart:
            urlString = "https://www.walmart.com/search?query=\(query)"
        case .target:
            urlString = "https://www.target.com/s?searchTerm=\(query)"
        case .bestbuy:
            urlString = "https://www.bestbuy.com/site/searchpage.jsp?st=\(query)"
        case .duckduckgo:
            urlString = "https://www.duckduckgo.com/?q=\(query)"
        }
        
        guard let url = URL(string: urlString) else { return }
        let viewController = SFSafariViewController(url: url)
        present(viewController, animated: true, completion: nil)
    }
}
