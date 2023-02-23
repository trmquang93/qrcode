//
//  QRScanResultViewController.swift
//  qrcode
//
//  Created by Quang Tran on 2/7/21.
//

import UIKit
import AppStarter
import UnitIAPHelper

class QRScanResultViewController: QRViewController, QRBannerEmbed, MCRatingProtocol {
    weak var codeView: UIImageView!
    weak var codeDetailView: UIView!
    
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
        showImage()
        rateMe(forKey: "QRScanResultViewController", maxCount: 3)
    }
    
    func showImage() {
        viewModel.generateCode {[weak self] image in
            DispatchQueue.main.async { [weak self] in
                self?.codeView.image = image
            }
        }
    }
    
    func setupResultView() {
        let viewController = viewModel.code.valueType == .number ? QRCodeLookupResultViewController(viewModel: viewModel) : QRResultViewController(viewModel: viewModel)
        
        addChild(viewController, to: codeDetailView)
    }
    
    
    
    func createConstraints() {
        view.layout(
            |bannerView|,
            20,
            |-10-codeView-10-| ~ 150,
            20,
            |codeDetailView|,
            0
        )
        
        bannerView
            .top(topAnchor)
        
    }
}

extension QRScanResultViewController: ViewControllerAutoCreateViews {
    
    func setupViews() {
        setupResultView()
        
        codeView.style {
            $0.contentMode = .scaleAspectFit
        }
    }
}
