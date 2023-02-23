//
//  VMCodeResult.swift
//  qrcode
//
//  Created by Quang Tran on 2/7/21.
//

import UIKit

class VMCodeResult {

    let code: QRCode
    
    init(code: QRCode) {
        self.code = code
    }
    
    func generateCode(completion: @escaping ((UIImage?) -> Void)) {
        code.generateCode(completion: completion) 
    }
}
