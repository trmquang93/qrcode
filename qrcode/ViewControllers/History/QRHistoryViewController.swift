//
//  QRHistoryViewController.swift
//  qrcode
//
//  Created by Quang Tran on 2/6/21.
//

import UIKit
import AppStarter
import MLKitBarcodeScanning

class QRHistoryViewController: QRViewController, ASTableViewControllerWithViewModel, QRBannerEmbed {
    weak var contentStackView: UIStackView!
    
    //sourcery:begin: superView = contentStackView, stackView
    weak var toolBar: UIView!
    //sourcery:end
        
    //sourcery:begin: ignore
    lazy var cancelButton: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelSelection))
    lazy var selectionButton: UIBarButtonItem = UIBarButtonItem(image: nil, style: .plain, target: self, action: #selector(selectionAction))
    var viewModel: VMHistory
    //sourcery:end
    
    init(viewModel: VMHistory = VMHistory()) {
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
        setup()
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
        cell.titleLabel.text = object?.code
        cell.dateLabel.text = object?.date.toString()
        cell.itemIcon.image = object
            .map({QRDecoder.decode($0.code)})
            .map({UIImage(named: $0.iconName)})?.map({$0})?
            .withRenderingMode(.alwaysTemplate)
        
        viewModel.selectingIndexPath()
            .subscribe(onNext: {[weak cell] selectingAll, selectingIndexPaths in
                guard let cell = cell, let cellIndexPath = tableView.indexPath(for: cell) else { return }
                let selecting = selectingAll || selectingIndexPaths.contains(cellIndexPath)
                cell.setSelecting(selecting)
            }).disposed(by: cell.disposeBag)
        
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
        
        cell.setEnableSelection(viewModel.isSelecting.value, animated: false)
        viewModel.isSelecting
            .skip(1)
            .subscribe(onNext: {[weak cell] selecting in
                cell?.setEnableSelection(selecting, animated: true)
            }).disposed(by: cell.disposeBag)
        
        cell.setEnableMenu(viewModel.shouldShowAccessory.value == indexPath, animated: false)
        viewModel.shouldShowAccessory
            .skip(1)
            .subscribe(onNext: {[weak cell] shouldShowAccessoryIndexPath in
                guard let cell = cell, let cellIndexPath = tableView.indexPath(for: cell) else { return }
                let show = shouldShowAccessoryIndexPath == cellIndexPath
                cell.setEnableMenu(show, animated: true)
                
            }).disposed(by: cell.disposeBag)
    }
    
    func setup() {
        tableView.allowsSelectionDuringEditing = true
        
    }
    
    func setupNavigation() {
        
        navigationItem.rightBarButtonItem = cancelButton
        

        viewModel.canSelect.subscribe(onNext: {[weak self] canSelect in
            self?.navigationItem.leftBarButtonItem = canSelect ? self?.selectionButton : nil
        }).disposed(by: disposeBag)
    }
    
    func setupRx() {
        viewModel.isSelecting.subscribe(onNext: {[weak self] selecting in
            let imageName = selecting ? "selection_true_ic" : "selection_false_ic"
            self?.selectionButton.image = UIImage(named: imageName)?.withRenderingMode(.alwaysOriginal)
            self?.cancelButton.isEnabled = selecting
            UIView.animate(withDuration: 0.2) {[weak self] in
                self?.qrTabBarController?.tabbar.isHidden = selecting
                self?.toolBar.isHidden = !selecting
            }
        }).disposed(by: disposeBag)
        
        viewModel.shouldShowAccessory
            .skip(1)
            .subscribe(onNext: {[weak self] current in
                self?.tableView.beginUpdates()
                self?.tableView.endUpdates()
        }).disposed(by: disposeBag)
    }
    
    func setupToolBar() {
        let copyButton = UIButton(type: .system)
        let deleteButton = UIButton(type: .system)
        
        copyButton.tintColor = .tintColor
        deleteButton.tintColor = .red
        
        copyButton.setTitle("copy_button".localized, for: .normal)
        deleteButton.setTitle("delete_button".localized, for: .normal)
        
        copyButton.addTarget(self, action: #selector(copySelectingItems), for: .touchUpInside)
        
        deleteButton.rx.tap.subscribe(onNext: {[weak self] in
            self?.deleteSelectingItems()
        }).disposed(by: deleteButton.disposeBag)
        
        let buttonsView = UIView()
        
        toolBar.subviews(
            buttonsView.subviews(
                copyButton,
                deleteButton
            )
        )
        
        toolBar.layout {
            0
            |-(>=0)-buttonsView-(>=0)-|
            0
        }
        
        buttonsView.layout {
            0
            |copyButton-60-deleteButton|
        }
        
        buttonsView
            .height(50)
            .centerHorizontally()
        
        toolBar.addTopBorderWithColor(thickness: 0.5)
        
        viewModel.selectingAny().subscribe(onNext: {[weak copyButton, weak deleteButton] selecting in
            copyButton?.isEnabled = selecting
            deleteButton?.isEnabled = selecting
        }).disposed(by: disposeBag)
    }
}

extension QRHistoryViewController: QRCodeListProtocol {
    func valueAt(indexPath: IndexPath) -> QRCode? {
        guard let item = viewModel.objectForIndexPath(indexPath) else {
            return nil
        }
        let code = QRCode(stringValue: item.code, codeType: BarcodeFormat(rawValue: item.codeType))
        return code
    }
    
    @objc func copySelectingItems() {
        UIPasteboard.general.items = viewModel.selectingContent()
        
        showAlert(withTitle: "copied_to_clipboard_title".localized, message: "copied_to_clipboard".localized)
    }
    
    @objc func deleteSelectingItems() {
        showWarnig(withTitle: "Delete_sure".localized, message: "Delete_msg".localized) {[unowned self] in
            self.viewModel.deleteSelectingItems()
            self.viewModel.disableSelection()
        }
    }
    
    func disableSelection() {
        viewModel.disableSelection()
    }
    
    func deleteAt(indexPath: IndexPath) {
        viewModel.deleteItem(at: indexPath)
    }
    
    @objc func tapView(gesture: UITapGestureRecognizer) {
        viewModel.shouldShowAccessory.accept(nil)
    }
}

extension QRHistoryViewController: ViewControllerAutoCreateViews {
    func setupViews() {
        setupTableView()
        setupToolBar()
        
        
        tableView.separatorStyle = .singleLine
        tableView.tableFooterView = UIView(frame: .zero)
        
        contentStackView
            .insertArrangedSubview(tableView, at: 0)
        
        contentStackView
            .insertArrangedSubview(bannerView, at: 0)
        
        contentStackView.style {
            $0.axis = .vertical
        }
        
        toolBar.isHidden = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapView(gesture:)))
        tap.delegate = self
        view.addGestureRecognizer(tap)
    }
    
    func createConstraints() {
        contentStackView
            .fillHorizontally()
            .top(topAnchor)
            .bottom(0)
        
        toolBar
            .top(bottomAnchor, constant: -50)
            .bottom(bottomAnchor)
        
    }
}

extension QRHistoryViewController: UIToolbarDelegate {
    func position(for bar: UIBarPositioning) -> UIBarPosition {
        return .bottom
    }
}

extension QRHistoryViewController: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        let locationTableView = gestureRecognizer.location(in: tableView)
        for cell in tableView.visibleCells {
            if cell.frame.contains(locationTableView) {
                return false
            }
        }
        return true
    }
}
extension QRHistoryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }
    
    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if viewModel.isSelecting.value {
            viewModel.selectIndexPath(indexPath)
        } else if let item = viewModel.objectForIndexPath(indexPath) {
            let codeFormat = BarcodeFormat(rawValue: item.codeType)
            let viewController = QRScanResultViewController(viewModel: VMCodeResult(code: QRCode(stringValue: item.code, codeType: codeFormat)))
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
            viewModel.shouldShowAccessory.accept(nil)
            return nil
        } else {
            return indexPath
        }
    }
}

extension QRHistoryViewController {
    @objc func cancelSelection() {
        viewModel.disableSelection()
    }
    
    @objc func selectionAction() {
        viewModel.selection()
    }
}
