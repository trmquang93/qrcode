//
//  QRMyCodeViewController.swift
//  qrcode
//
//  Created by Quang Tran on 2/19/21.
//

import UIKit
import AppStarter
import MLKitBarcodeScanning

class QRMyCodeViewController: QRViewController, ASTableViewControllerWithViewModel, QRBannerEmbed {
    weak var emptyContentView: UIView!
    
    //sourcery:begin: superView = emptyContentView
    weak var emptyIconView: UIImageView!
    weak var emptyTitleLabel: UILabel!
    weak var emptyMessageLabel: UILabel!
    //sourcery:end
        
    //sourcery:begin: ignore
    var viewModel: VMMyCode
    //sourcery:end
    
    init(viewModel: VMMyCode = VMMyCode()) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
        
        tableViewDataSource = ASTableViewDataSource(viewModel: viewModel, viewController: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        createConstraints()
        setupNavigation()
        setupRx()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.markAllAsSeen()
    }
    
    func setupCell(_ tableView: UITableView, cell: UITableViewCell, at indexPath: IndexPath) {
        guard let cell = cell as? QRHistoryCell else { return }
        let object = viewModel.objectForIndexPath(indexPath)
        let codeType = object.map({QRDecoder.decode($0.code)})
        
        cell.titleLabel.text = codeType?.name
        cell.dateLabel.text = object?.code
        cell.itemIcon.image = UIImage(named: "qrcode")
        
        cell.accessoryContainerView.rx.tap.subscribe(onNext: {[weak self, weak cell] in
            guard let cell = cell, let cellIndexPath = tableView.indexPath(for: cell) else { return }
            self?.viewModel.shouldShowAccessory.accept(cellIndexPath)
        }).disposed(by: cell.disposeBag)
        
        cell.menuView.copyButton.rx.tap.subscribe(onNext: {[weak self, weak cell] in
            guard let cell = cell, let cellIndexPath = tableView.indexPath(for: cell) else { return }
            self?.copyItem(at: cellIndexPath)
        }).disposed(by: cell.disposeBag)
        
        cell.menuView.openButton.rx.tap.subscribe(onNext: {[weak self, weak cell] in
            guard let cell = cell, let cellIndexPath = tableView.indexPath(for: cell) else { return }
            self?.shareItem(at: cellIndexPath, from: cell)
        }).disposed(by: cell.disposeBag)
        
        cell.menuView.deleteButton.rx.tap.subscribe(onNext: {[weak self, weak cell] in
            guard let cell = cell, let cellIndexPath = tableView.indexPath(for: cell) else { return }
            self?.deleteAt(indexPath: cellIndexPath)
        }).disposed(by: cell.disposeBag)
        
        viewModel.shouldShowAccessory
            .subscribe(onNext: {[weak cell] shouldShowAccessoryIndexPath in
                guard let cell = cell, let cellIndexPath = tableView.indexPath(for: cell) else { return }
                let show = shouldShowAccessoryIndexPath == cellIndexPath
                cell.setEnableMenu(show, animated: true)
                
            }).disposed(by: cell.disposeBag)
    }
}
extension QRMyCodeViewController {
    @objc func createCode() {
        let viewController = QRCreateViewController()
        navigationController?.pushViewController(viewController, animated: true)
    }
}
extension QRMyCodeViewController {
    func setupNavigation() {
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(createCode))
        navigationItem.rightBarButtonItem = addButton
    }
    
    func setupRx() {
        viewModel.isEmpty.subscribe(onNext: {[weak self] isEmpty in
            self?.tableView.isHidden = isEmpty
            self?.emptyContentView.isHidden = !isEmpty
        }).disposed(by: disposeBag)
        
        viewModel.shouldShowAccessory
            .skip(1)
            .subscribe(onNext: {[weak self] current in
                self?.tableView.beginUpdates()
                self?.tableView.endUpdates()
            }).disposed(by: disposeBag)
        
    }
}

extension QRMyCodeViewController: QRCodeListProtocol {
    func disableSelection() {
        
    }
    
    func valueAt(indexPath: IndexPath) -> QRCode? {
        guard let object = viewModel.objectForIndexPath(indexPath) else { return nil }
        return QRCode(stringValue: object.code, codeType: .qrCode)
    }
    
    func deleteAt(indexPath: IndexPath) {
        viewModel.deleteItem(at: indexPath)
    }
    
    
}

extension QRMyCodeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let item = viewModel.objectForIndexPath(indexPath) {
            let viewController = QRScanResultViewController(viewModel: VMCodeResult(code: QRCode(stringValue: item.code, codeType: .qrCode)))
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if viewModel.shouldShowAccessory.value == indexPath {
            return 140
        }
        return 60
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if indexPath == viewModel.shouldShowAccessory.value {
            return nil
        } else {
            return indexPath
        }
    }
}

extension QRMyCodeViewController: ViewControllerAutoCreateViews {
    func setupViews() {
        setupTableView()
        view.sendSubviewToBack(tableView)
        
        emptyIconView.style {
            $0.image = UIImage(named: "empty_create")?.withRenderingMode(.alwaysOriginal)
        }
        
        emptyTitleLabel.style {
            $0.textAlignment = .center
            $0.font = UIFont.bold.withSize(24)
            $0.textColor = .tintColor
            $0.text = "empty_created_code".localized
        }
        
        emptyMessageLabel.style {
            $0.textAlignment = .center
            $0.font = UIFont.default
            $0.textColor = .seperatorColor
            $0.text = "click_plus_to_create_code".localized
        }
    }
    
    func createConstraints() {
        bannerView
            .fillHorizontally()
            .top(topAnchor)
        
        tableView
            .top(bannerView.bottomAnchor)
            .bottom(0)
            .fillHorizontally()
        
        emptyContentView
            .centerVertically()
            .centerHorizontally()
        
        emptyContentView.layout(
            0,
            |-(>=0)-emptyIconView-(>=0)-| ~ 180,
            10,
            |emptyTitleLabel| ~ 30,
            10,
            |emptyMessageLabel|,
            0
        )
        
        emptyIconView
            .centerHorizontally()
            .width(175)
    }
}
