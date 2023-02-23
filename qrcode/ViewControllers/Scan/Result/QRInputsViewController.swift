//
//  QREmailViewController.swift
//  qrcode
//
//  Created by Quang Tran on 2/7/21.
//

import UIKit
import AppStarter
import RxSwift
import RxCocoa

class QRInputsViewController: QRViewController, ViewControllerAutoCreateViews {
    weak var scrollView: UIScrollView!
    
    //sourcery:begin: superView = scrollView
    weak var stackContainer: UIStackView!
    //sourcery:end
    
    //sourcery:begin: ignore
    var labelsWidth: CGFloat { return 70 }
    let isEnabled: Bool
    let inputFields: [QRInputField]
    let data = BehaviorRelay<[Int: Any]>(value: [:])
    //sourcery:end
    
    init(inputFields: [QRInputField], isEnabled: Bool = true) {
        self.inputFields = inputFields
        self.isEnabled = isEnabled
        
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
    
    func setupViews() {
        
        for (index,field) in inputFields.enumerated() {
            let stackView = UIStackView()
            let label = UILabel()
            
            let rowHeight: CGFloat = 50
            
            if field.isTextView {
                let textView = TextViewWithPlaceholder()
                textView.translatesAutoresizingMaskIntoConstraints = false
                textView.style {
                    $0.font = .default
                    $0.layer.cornerRadius = 5
                    $0.layer.borderWidth = 0.5
                    $0.layer.borderColor = UIColor.seperatorColor.cgColor
                    $0.text = field.value
                    $0.placeholder = field.placeHolder
                    $0.isEditable = isEnabled
                }
                
                textView
                    .height(rowHeight * 3)
                
                stackView.addArrangedSubview(textView)
                
                textView.rx.text.subscribe(onNext: {[weak self] text in
                    guard let `self` = self else { return }
                    var data = self.data.value
                    data[index] = text
                    self.data.accept(data)
                }).disposed(by: textView.disposeBag)
                
            } else {
                let textField = TextScrollView()
                textField.textView.translatesAutoresizingMaskIntoConstraints = false
                textField.textView.style {
                    $0.font = .default
                    $0.addBottomBorderWithColor(thickness: 0.5)
                    $0.text = field.value
                    $0.isEditable = isEnabled
                    $0.placeholder = field.placeHolder
                }
                
                textField.backgroundColor = isEnabled ? .backgroundColor : .textBackgroundColor
                
                textField
                    .height(rowHeight)
                
                textField.textView.rx.text.subscribe(onNext: {[weak self] text in
                    guard let `self` = self else { return }
                    var data = self.data.value
                    data[index] = text
                    self.data.accept(data)
                }).disposed(by: textField.disposeBag)
                
                stackView.addArrangedSubview(textField)
            }
            
            
            
            stackView.translatesAutoresizingMaskIntoConstraints = false
            label.translatesAutoresizingMaskIntoConstraints = false
            
            
            label.font = .default
            label.text = field.label.rawValue.localized
            
            
            
            label
                .width(labelsWidth)
                .height(rowHeight)
            
            
            
            stackView.axis = .horizontal
            stackView.spacing = 10
            stackView.alignment = .top
            
            stackView.insertArrangedSubview(label, at: 0)
            
            stackContainer.addArrangedSubview(stackView)
            stackContainer.spacing = 5
        }
        
        stackContainer.axis = .vertical
    }
    
    func createConstraints() {
        |-20-scrollView-20-|
        
        scrollView
            .top(0)
            .bottom(0)
        
        stackContainer
            .fillContainer()
            .width(view.widthAnchor, constant: -40)
    }
}
