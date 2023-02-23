//
//  QRImagePicker.swift
//  qrcode
//
//  Created by Quang Tran on 2/8/21.
//

import UIKit
import MobileCoreServices
import RxSwift
import RxCocoa
import MBProgressHUD

class QRImagePicker: NSObject {
    typealias QRImagePickerCompletion = (UIImage?) -> Void
    
    private override init() {
        super.init()
        
    }
    
    static func show(from vc: UIViewController, completion: QRImagePickerCompletion?) {
        let picker = UIImagePickerController()
        picker.modalPresentationStyle = .fullScreen
        picker.mediaTypes = [kUTTypeImage as String ]
        vc.present(picker, animated: true, completion: nil)
        
        picker.rx.didFinishPickingMediaWithInfo.subscribe(onNext: { info in
            let image = (info[.editedImage] ?? info[.originalImage]) as? UIImage
            picker.dismiss(animated: true) {
                completion?(image)
            }
        }).disposed(by: picker.disposeBag)
    }
}

class RxImagePickerDelegateProxy: DelegateProxy<UIImagePickerController, (UINavigationControllerDelegate & UIImagePickerControllerDelegate)>, RxCocoa.DelegateProxyType, (UINavigationControllerDelegate & UIImagePickerControllerDelegate) {
    static func currentDelegate(for object: UIImagePickerController) -> (UIImagePickerControllerDelegate & UINavigationControllerDelegate)? {
        return object.delegate
    }
    
    static func setCurrentDelegate(_ delegate: (UIImagePickerControllerDelegate & UINavigationControllerDelegate)?, to object: UIImagePickerController) {
        object.delegate = delegate
    }
    
    
    init(imagePicker: UIImagePickerController) {
        super.init(parentObject: imagePicker, delegateProxy: RxImagePickerDelegateProxy.self)
    }
    
    public static func registerKnownImplementations() {
        self.register { RxImagePickerDelegateProxy(imagePicker: $0) }
    }
    
}

extension Reactive where Base: UIImagePickerController {
    var imagePickerDelegate: RxImagePickerDelegateProxy {
        return RxImagePickerDelegateProxy.proxy(for: base)
    }
    /**
     
     Reactive wrapper for `delegate` message.
     */
    public var didFinishPickingMediaWithInfo: Observable<[UIImagePickerController.InfoKey : AnyObject]> {
        return imagePickerDelegate
            .methodInvoked(#selector(UIImagePickerControllerDelegate.imagePickerController(_:didFinishPickingMediaWithInfo:)))
            .map({ (a) in
                return try Self.castOrThrow(Dictionary<UIImagePickerController.InfoKey, AnyObject>.self, a[1])
            })
    }

    /**
     Reactive wrapper for `delegate` message.
     */
    public var didCancel: Observable<()> {
        return imagePickerDelegate
            .methodInvoked(#selector(UIImagePickerControllerDelegate.imagePickerControllerDidCancel(_:)))
            .map {_ in () }
    }
    
    static private func castOrThrow<T>(_ resultType: T.Type, _ object: Any) throws -> T {
        guard let returnValue = object as? T else {
            throw RxCocoaError.castingError(object: object, targetType: resultType)
        }

        return returnValue
    }
}

